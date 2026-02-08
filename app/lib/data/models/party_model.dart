import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'party_model.freezed.dart';
part 'party_model.g.dart';

enum PartyStatus {
  recruiting,
  confirmed,
  completed,
  cancelled,
}

enum LocationType {
  @JsonValue('company_nearby') companyNearby,
  midpoint,
  specific,
}

@freezed
class PartyModel with _$PartyModel {
  const factory PartyModel({
    @JsonKey(name: 'party_id') required String partyId,
    @JsonKey(name: 'creator_id') required String creatorId,
    required UserModel creator, // 간소화된 User 정보가 올 수 있음
    required String title,
    String? description,
    
    @JsonKey(name: 'location_type') required LocationType locationType,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lon') double? locationLon,
    @JsonKey(name: 'location_name') String? locationName,
    
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    
    @JsonKey(name: 'max_participants') required int maxParticipants,
    @JsonKey(name: 'min_participants') required int minParticipants,
    @JsonKey(name: 'current_participants') required int currentParticipants,
    
    required PartyStatus status,
    
    @JsonKey(name: 'distance_km') double? distanceKm, // 목록 조회 시 포함
    
    @Default([]) List<PartyParticipantModel> participants,
    
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PartyModel;

  factory PartyModel.fromJson(Map<String, dynamic> json) => _$PartyModelFromJson(json);
}

@freezed
class PartyParticipantModel with _$PartyParticipantModel {
  const factory PartyParticipantModel({
    @JsonKey(name: 'participant_id') required String participantId,
    @JsonKey(name: 'user_id') required String userId,
    required UserModel user,
    required String status, // joined, left
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
  }) = _PartyParticipantModel;

  factory PartyParticipantModel.fromJson(Map<String, dynamic> json) => _$PartyParticipantModelFromJson(json);
}
