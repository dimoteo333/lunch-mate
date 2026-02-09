import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';
import '../models/party_model.dart';

final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  return PartyRepository(ref.read(dioProvider));
});

class PartyRepository {
  final Dio _dio;

  PartyRepository(this._dio);

  Future<List<PartyModel>> getParties({
    double? lat,
    double? lon,
    double? radius,
    String? locationType,
    String? sortBy,
  }) async {
    final queryParams = <String, dynamic>{
      if (lat != null) 'latitude': lat,
      if (lon != null) 'longitude': lon,
      if (radius != null) 'radius_km': radius,
      if (locationType != null) 'location_type': locationType,
      if (sortBy != null) 'sort_by': sortBy,
    };

    final response = await _dio.get(
      ApiConstants.parties,
      queryParameters: queryParams,
    );
    
    final List items = response.data['items'] ?? [];
    return items.map((json) => PartyModel.fromJson(json)).toList();
  }

  Future<PartyModel> getParty(String partyId) async {
    final response = await _dio.get('${ApiConstants.parties}/$partyId');
    return PartyModel.fromJson(response.data);
  }

  Future<PartyModel> createParty(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.parties, data: data);
    return PartyModel.fromJson(response.data);
  }

  Future<void> joinParty(String partyId) async {
    await _dio.post('${ApiConstants.parties}/$partyId/join');
  }

  Future<void> leaveParty(String partyId) async {
    await _dio.delete('${ApiConstants.parties}/$partyId/leave');
  }
}
