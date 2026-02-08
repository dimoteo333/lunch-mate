import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/data/models/party_model.dart';
import 'package:app/data/repositories/party_repository.dart';

// 필터 상태
class PartyFilterState {
  final double? lat;
  final double? lon;
  final double radiusKm;
  final String? locationType;
  final String sortBy;

  PartyFilterState({
    this.lat,
    this.lon,
    this.radiusKm = 1.0,
    this.locationType,
    this.sortBy = 'created_at',
  });

  PartyFilterState copyWith({
    double? lat,
    double? lon,
    double? radiusKm,
    String? locationType,
    String? sortBy,
  }) {
    return PartyFilterState(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      radiusKm: radiusKm ?? this.radiusKm,
      locationType: locationType ?? this.locationType,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

final partyFilterProvider = StateProvider<PartyFilterState>((ref) {
  // TODO: 위치 권한 획득 후 초기 좌표 설정 필요
  return PartyFilterState();
});

// 파티 목록 Provider (FutureProvider)
final partyListProvider = FutureProvider.autoDispose<List<PartyModel>>((ref) async {
  final repository = ref.watch(partyRepositoryProvider);
  final filter = ref.watch(partyFilterProvider);

  return repository.getParties(
    lat: filter.lat,
    lon: filter.lon,
    radius: filter.radiusKm,
    locationType: filter.locationType,
    sortBy: filter.sortBy,
  );
});

// 파티 상세 Provider (Family)
final partyDetailProvider = FutureProvider.autoDispose.family<PartyModel, String>((ref, partyId) async {
  final repository = ref.watch(partyRepositoryProvider);
  return repository.getParty(partyId);
});

// 파티 액션 Controller
final partyControllerProvider = StateNotifierProvider<PartyController, AsyncValue<void>>((ref) {
  return PartyController(ref.read(partyRepositoryProvider), ref);
});

class PartyController extends StateNotifier<AsyncValue<void>> {
  final PartyRepository _repository;
  final Ref _ref;

  PartyController(this._repository, this._ref) : super(const AsyncData(null));

  Future<void> createParty(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.createParty(data);
      _ref.invalidate(partyListProvider); // 목록 갱신
    });
  }

  Future<void> joinParty(String partyId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.joinParty(partyId);
      _ref.invalidate(partyDetailProvider(partyId)); // 상세 갱신
      _ref.invalidate(partyListProvider); // 목록 갱신
    });
  }

  Future<void> leaveParty(String partyId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.leaveParty(partyId);
      _ref.invalidate(partyDetailProvider(partyId));
      _ref.invalidate(partyListProvider);
    });
  }
}
