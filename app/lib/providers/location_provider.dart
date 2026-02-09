import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app/data/repositories/kakao_repository.dart';
import 'package:app/providers/party_provider.dart';

class LocationState {
  final double? lat;
  final double? lon;
  final String? addressName;
  final String? shortAddress;
  final bool isLoading;
  final String? error;
  final bool permissionDenied;

  LocationState({
    this.lat,
    this.lon,
    this.addressName,
    this.shortAddress,
    this.isLoading = false,
    this.error,
    this.permissionDenied = false,
  });

  LocationState copyWith({
    double? lat,
    double? lon,
    String? addressName,
    String? shortAddress,
    bool? isLoading,
    String? error,
    bool? permissionDenied,
  }) {
    return LocationState(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      addressName: addressName ?? this.addressName,
      shortAddress: shortAddress ?? this.shortAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(
    ref.read(kakaoRepositoryProvider),
    ref,
  );
});

class LocationNotifier extends StateNotifier<LocationState> {
  final KakaoRepository _kakaoRepo;
  final Ref _ref;

  LocationNotifier(this._kakaoRepo, this._ref) : super(LocationState());

  Future<void> getCurrentLocation() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 위치 서비스 활성화 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          error: '위치 서비스가 비활성화되어 있습니다',
        );
        return;
      }

      // 2. 권한 확인 및 요청
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            error: '위치 권한이 거부되었습니다',
            permissionDenied: true,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          error: '위치 권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.',
          permissionDenied: true,
        );
        return;
      }

      // 3. 현재 위치 획득
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      state = state.copyWith(
        lat: position.latitude,
        lon: position.longitude,
      );

      // 4. 역지오코딩으로 주소 업데이트
      try {
        final address = await _kakaoRepo.coordToAddress(
          position.latitude,
          position.longitude,
        );
        if (address != null) {
          state = state.copyWith(
            addressName: address.fullAddress,
            shortAddress: address.shortAddress,
          );
        }
      } catch (_) {
        // 역지오코딩 실패는 무시 (좌표는 이미 획득)
      }

      // 5. partyFilterProvider에 위치 업데이트 → partyListProvider 자동 재조회
      _ref.read(partyFilterProvider.notifier).state =
          _ref.read(partyFilterProvider).copyWith(
                lat: position.latitude,
                lon: position.longitude,
              );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '위치를 가져올 수 없습니다: $e',
      );
    }
  }
}
