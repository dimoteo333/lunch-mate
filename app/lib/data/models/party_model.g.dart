// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartyModelImpl _$$PartyModelImplFromJson(Map<String, dynamic> json) =>
    _$PartyModelImpl(
      partyId: json['party_id'] as String,
      creatorId: json['creator_id'] as String,
      creator: UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String?,
      locationType: $enumDecode(_$LocationTypeEnumMap, json['location_type']),
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLon: (json['location_lon'] as num?)?.toDouble(),
      locationName: json['location_name'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      maxParticipants: (json['max_participants'] as num).toInt(),
      minParticipants: (json['min_participants'] as num).toInt(),
      currentParticipants: (json['current_participants'] as num).toInt(),
      status: $enumDecode(_$PartyStatusEnumMap, json['status']),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PartyParticipantModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PartyModelImplToJson(_$PartyModelImpl instance) =>
    <String, dynamic>{
      'party_id': instance.partyId,
      'creator_id': instance.creatorId,
      'creator': instance.creator,
      'title': instance.title,
      'description': instance.description,
      'location_type': _$LocationTypeEnumMap[instance.locationType]!,
      'location_lat': instance.locationLat,
      'location_lon': instance.locationLon,
      'location_name': instance.locationName,
      'start_time': instance.startTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'max_participants': instance.maxParticipants,
      'min_participants': instance.minParticipants,
      'current_participants': instance.currentParticipants,
      'status': _$PartyStatusEnumMap[instance.status]!,
      'distance_km': instance.distanceKm,
      'participants': instance.participants,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$LocationTypeEnumMap = {
  LocationType.companyNearby: 'company_nearby',
  LocationType.midpoint: 'midpoint',
  LocationType.specific: 'specific',
};

const _$PartyStatusEnumMap = {
  PartyStatus.recruiting: 'recruiting',
  PartyStatus.confirmed: 'confirmed',
  PartyStatus.completed: 'completed',
  PartyStatus.cancelled: 'cancelled',
};

_$PartyParticipantModelImpl _$$PartyParticipantModelImplFromJson(
  Map<String, dynamic> json,
) => _$PartyParticipantModelImpl(
  participantId: json['participant_id'] as String,
  userId: json['user_id'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  status: json['status'] as String,
  joinedAt: DateTime.parse(json['joined_at'] as String),
);

Map<String, dynamic> _$$PartyParticipantModelImplToJson(
  _$PartyParticipantModelImpl instance,
) => <String, dynamic>{
  'participant_id': instance.participantId,
  'user_id': instance.userId,
  'user': instance.user,
  'status': instance.status,
  'joined_at': instance.joinedAt.toIso8601String(),
};
