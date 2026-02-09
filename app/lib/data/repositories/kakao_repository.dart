import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';

// Models
class KakaoPlace {
  final String placeName;
  final String addressName;
  final String? roadAddressName;
  final String? categoryName;
  final double lat;
  final double lon;
  final int? distance;
  final String? phone;
  final String? placeUrl;

  KakaoPlace({
    required this.placeName,
    required this.addressName,
    this.roadAddressName,
    this.categoryName,
    required this.lat,
    required this.lon,
    this.distance,
    this.phone,
    this.placeUrl,
  });

  factory KakaoPlace.fromJson(Map<String, dynamic> json) {
    return KakaoPlace(
      placeName: json['place_name'] ?? '',
      addressName: json['address_name'] ?? '',
      roadAddressName: json['road_address_name'],
      categoryName: json['category_name'],
      lat: double.parse(json['y']),
      lon: double.parse(json['x']),
      distance: json['distance'] != null && json['distance'] != ''
          ? int.parse(json['distance'])
          : null,
      phone: json['phone'],
      placeUrl: json['place_url'],
    );
  }
}

class KakaoAddress {
  final String fullAddress;
  final String shortAddress;
  final String? region1; // 시/도
  final String? region2; // 구
  final String? region3; // 동

  KakaoAddress({
    required this.fullAddress,
    required this.shortAddress,
    this.region1,
    this.region2,
    this.region3,
  });
}

// Provider
final kakaoRepositoryProvider = Provider<KakaoRepository>((ref) {
  return KakaoRepository();
});

class KakaoRepository {
  late final Dio _dio;

  KakaoRepository() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.kakaoBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Authorization': 'KakaoAK ${ApiConstants.kakaoRestApiKey}',
      },
    ));
  }

  /// 키워드 검색
  Future<List<KakaoPlace>> searchKeyword(
    String query, {
    double? lat,
    double? lon,
    int radius = 3000,
    int page = 1,
    int size = 15,
  }) async {
    final params = <String, dynamic>{
      'query': query,
      'page': page,
      'size': size,
    };
    // 카카오 API는 x=경도, y=위도 순서
    if (lat != null && lon != null) {
      params['y'] = lat;
      params['x'] = lon;
      params['radius'] = radius;
      params['sort'] = 'distance';
    }

    final response = await _dio.get(
      ApiConstants.kakaoKeywordSearch,
      queryParameters: params,
    );

    final List documents = response.data['documents'] ?? [];
    return documents.map((doc) => KakaoPlace.fromJson(doc)).toList();
  }

  /// 카테고리 검색 (FD6=음식점, CE7=카페)
  Future<List<KakaoPlace>> searchCategory(
    String categoryCode, {
    required double lat,
    required double lon,
    int radius = 3000,
    int page = 1,
    int size = 15,
  }) async {
    final response = await _dio.get(
      ApiConstants.kakaoCategorySearch,
      queryParameters: {
        'category_group_code': categoryCode,
        'y': lat,
        'x': lon,
        'radius': radius,
        'sort': 'distance',
        'page': page,
        'size': size,
      },
    );

    final List documents = response.data['documents'] ?? [];
    return documents.map((doc) => KakaoPlace.fromJson(doc)).toList();
  }

  /// 좌표 → 주소 변환 (역지오코딩)
  Future<KakaoAddress?> coordToAddress(double lat, double lon) async {
    final response = await _dio.get(
      ApiConstants.kakaoCoord2Region,
      queryParameters: {
        'y': lat,
        'x': lon,
      },
    );

    final List documents = response.data['documents'] ?? [];
    if (documents.isEmpty) return null;

    // 행정동(region_type == 'H') 우선
    final doc = documents.firstWhere(
      (d) => d['region_type'] == 'H',
      orElse: () => documents.first,
    );

    final region1 = doc['region_1depth_name'] ?? '';
    final region2 = doc['region_2depth_name'] ?? '';
    final region3 = doc['region_3depth_name'] ?? '';

    return KakaoAddress(
      fullAddress: '$region1 $region2 $region3'.trim(),
      shortAddress: '$region2 $region3'.trim(),
      region1: region1,
      region2: region2,
      region3: region3,
    );
  }
}
