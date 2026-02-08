// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PartyModel _$PartyModelFromJson(Map<String, dynamic> json) {
  return _PartyModel.fromJson(json);
}

/// @nodoc
mixin _$PartyModel {
  @JsonKey(name: 'party_id')
  String get partyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  String get creatorId => throw _privateConstructorUsedError;
  UserModel get creator =>
      throw _privateConstructorUsedError; // 간소화된 User 정보가 올 수 있음
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  LocationType get locationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lat')
  double? get locationLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_lon')
  double? get locationLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_participants')
  int get maxParticipants => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_participants')
  int get minParticipants => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_participants')
  int get currentParticipants => throw _privateConstructorUsedError;
  PartyStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError; // 목록 조회 시 포함
  List<PartyParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PartyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyModelCopyWith<PartyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyModelCopyWith<$Res> {
  factory $PartyModelCopyWith(
    PartyModel value,
    $Res Function(PartyModel) then,
  ) = _$PartyModelCopyWithImpl<$Res, PartyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'party_id') String partyId,
    @JsonKey(name: 'creator_id') String creatorId,
    UserModel creator,
    String title,
    String? description,
    @JsonKey(name: 'location_type') LocationType locationType,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lon') double? locationLon,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'start_time') DateTime startTime,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    @JsonKey(name: 'max_participants') int maxParticipants,
    @JsonKey(name: 'min_participants') int minParticipants,
    @JsonKey(name: 'current_participants') int currentParticipants,
    PartyStatus status,
    @JsonKey(name: 'distance_km') double? distanceKm,
    List<PartyParticipantModel> participants,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  $UserModelCopyWith<$Res> get creator;
}

/// @nodoc
class _$PartyModelCopyWithImpl<$Res, $Val extends PartyModel>
    implements $PartyModelCopyWith<$Res> {
  _$PartyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyId = null,
    Object? creatorId = null,
    Object? creator = null,
    Object? title = null,
    Object? description = freezed,
    Object? locationType = null,
    Object? locationLat = freezed,
    Object? locationLon = freezed,
    Object? locationName = freezed,
    Object? startTime = null,
    Object? durationMinutes = null,
    Object? maxParticipants = null,
    Object? minParticipants = null,
    Object? currentParticipants = null,
    Object? status = null,
    Object? distanceKm = freezed,
    Object? participants = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            partyId: null == partyId
                ? _value.partyId
                : partyId // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorId: null == creatorId
                ? _value.creatorId
                : creatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            creator: null == creator
                ? _value.creator
                : creator // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationType: null == locationType
                ? _value.locationType
                : locationType // ignore: cast_nullable_to_non_nullable
                      as LocationType,
            locationLat: freezed == locationLat
                ? _value.locationLat
                : locationLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            locationLon: freezed == locationLon
                ? _value.locationLon
                : locationLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            locationName: freezed == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            maxParticipants: null == maxParticipants
                ? _value.maxParticipants
                : maxParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            minParticipants: null == minParticipants
                ? _value.minParticipants
                : minParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            currentParticipants: null == currentParticipants
                ? _value.currentParticipants
                : currentParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PartyStatus,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<PartyParticipantModel>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get creator {
    return $UserModelCopyWith<$Res>(_value.creator, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartyModelImplCopyWith<$Res>
    implements $PartyModelCopyWith<$Res> {
  factory _$$PartyModelImplCopyWith(
    _$PartyModelImpl value,
    $Res Function(_$PartyModelImpl) then,
  ) = __$$PartyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'party_id') String partyId,
    @JsonKey(name: 'creator_id') String creatorId,
    UserModel creator,
    String title,
    String? description,
    @JsonKey(name: 'location_type') LocationType locationType,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lon') double? locationLon,
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'start_time') DateTime startTime,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    @JsonKey(name: 'max_participants') int maxParticipants,
    @JsonKey(name: 'min_participants') int minParticipants,
    @JsonKey(name: 'current_participants') int currentParticipants,
    PartyStatus status,
    @JsonKey(name: 'distance_km') double? distanceKm,
    List<PartyParticipantModel> participants,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });

  @override
  $UserModelCopyWith<$Res> get creator;
}

/// @nodoc
class __$$PartyModelImplCopyWithImpl<$Res>
    extends _$PartyModelCopyWithImpl<$Res, _$PartyModelImpl>
    implements _$$PartyModelImplCopyWith<$Res> {
  __$$PartyModelImplCopyWithImpl(
    _$PartyModelImpl _value,
    $Res Function(_$PartyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyId = null,
    Object? creatorId = null,
    Object? creator = null,
    Object? title = null,
    Object? description = freezed,
    Object? locationType = null,
    Object? locationLat = freezed,
    Object? locationLon = freezed,
    Object? locationName = freezed,
    Object? startTime = null,
    Object? durationMinutes = null,
    Object? maxParticipants = null,
    Object? minParticipants = null,
    Object? currentParticipants = null,
    Object? status = null,
    Object? distanceKm = freezed,
    Object? participants = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$PartyModelImpl(
        partyId: null == partyId
            ? _value.partyId
            : partyId // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        creator: null == creator
            ? _value.creator
            : creator // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationType: null == locationType
            ? _value.locationType
            : locationType // ignore: cast_nullable_to_non_nullable
                  as LocationType,
        locationLat: freezed == locationLat
            ? _value.locationLat
            : locationLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        locationLon: freezed == locationLon
            ? _value.locationLon
            : locationLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        locationName: freezed == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        maxParticipants: null == maxParticipants
            ? _value.maxParticipants
            : maxParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        minParticipants: null == minParticipants
            ? _value.minParticipants
            : minParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        currentParticipants: null == currentParticipants
            ? _value.currentParticipants
            : currentParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PartyStatus,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<PartyParticipantModel>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyModelImpl implements _PartyModel {
  const _$PartyModelImpl({
    @JsonKey(name: 'party_id') required this.partyId,
    @JsonKey(name: 'creator_id') required this.creatorId,
    required this.creator,
    required this.title,
    this.description,
    @JsonKey(name: 'location_type') required this.locationType,
    @JsonKey(name: 'location_lat') this.locationLat,
    @JsonKey(name: 'location_lon') this.locationLon,
    @JsonKey(name: 'location_name') this.locationName,
    @JsonKey(name: 'start_time') required this.startTime,
    @JsonKey(name: 'duration_minutes') required this.durationMinutes,
    @JsonKey(name: 'max_participants') required this.maxParticipants,
    @JsonKey(name: 'min_participants') required this.minParticipants,
    @JsonKey(name: 'current_participants') required this.currentParticipants,
    required this.status,
    @JsonKey(name: 'distance_km') this.distanceKm,
    final List<PartyParticipantModel> participants = const [],
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _participants = participants;

  factory _$PartyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyModelImplFromJson(json);

  @override
  @JsonKey(name: 'party_id')
  final String partyId;
  @override
  @JsonKey(name: 'creator_id')
  final String creatorId;
  @override
  final UserModel creator;
  // 간소화된 User 정보가 올 수 있음
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'location_type')
  final LocationType locationType;
  @override
  @JsonKey(name: 'location_lat')
  final double? locationLat;
  @override
  @JsonKey(name: 'location_lon')
  final double? locationLon;
  @override
  @JsonKey(name: 'location_name')
  final String? locationName;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @override
  @JsonKey(name: 'max_participants')
  final int maxParticipants;
  @override
  @JsonKey(name: 'min_participants')
  final int minParticipants;
  @override
  @JsonKey(name: 'current_participants')
  final int currentParticipants;
  @override
  final PartyStatus status;
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  // 목록 조회 시 포함
  final List<PartyParticipantModel> _participants;
  // 목록 조회 시 포함
  @override
  @JsonKey()
  List<PartyParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'PartyModel(partyId: $partyId, creatorId: $creatorId, creator: $creator, title: $title, description: $description, locationType: $locationType, locationLat: $locationLat, locationLon: $locationLon, locationName: $locationName, startTime: $startTime, durationMinutes: $durationMinutes, maxParticipants: $maxParticipants, minParticipants: $minParticipants, currentParticipants: $currentParticipants, status: $status, distanceKm: $distanceKm, participants: $participants, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyModelImpl &&
            (identical(other.partyId, partyId) || other.partyId == partyId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLon, locationLon) ||
                other.locationLon == locationLon) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.minParticipants, minParticipants) ||
                other.minParticipants == minParticipants) &&
            (identical(other.currentParticipants, currentParticipants) ||
                other.currentParticipants == currentParticipants) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    partyId,
    creatorId,
    creator,
    title,
    description,
    locationType,
    locationLat,
    locationLon,
    locationName,
    startTime,
    durationMinutes,
    maxParticipants,
    minParticipants,
    currentParticipants,
    status,
    distanceKm,
    const DeepCollectionEquality().hash(_participants),
    createdAt,
  );

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyModelImplCopyWith<_$PartyModelImpl> get copyWith =>
      __$$PartyModelImplCopyWithImpl<_$PartyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyModelImplToJson(this);
  }
}

abstract class _PartyModel implements PartyModel {
  const factory _PartyModel({
    @JsonKey(name: 'party_id') required final String partyId,
    @JsonKey(name: 'creator_id') required final String creatorId,
    required final UserModel creator,
    required final String title,
    final String? description,
    @JsonKey(name: 'location_type') required final LocationType locationType,
    @JsonKey(name: 'location_lat') final double? locationLat,
    @JsonKey(name: 'location_lon') final double? locationLon,
    @JsonKey(name: 'location_name') final String? locationName,
    @JsonKey(name: 'start_time') required final DateTime startTime,
    @JsonKey(name: 'duration_minutes') required final int durationMinutes,
    @JsonKey(name: 'max_participants') required final int maxParticipants,
    @JsonKey(name: 'min_participants') required final int minParticipants,
    @JsonKey(name: 'current_participants')
    required final int currentParticipants,
    required final PartyStatus status,
    @JsonKey(name: 'distance_km') final double? distanceKm,
    final List<PartyParticipantModel> participants,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$PartyModelImpl;

  factory _PartyModel.fromJson(Map<String, dynamic> json) =
      _$PartyModelImpl.fromJson;

  @override
  @JsonKey(name: 'party_id')
  String get partyId;
  @override
  @JsonKey(name: 'creator_id')
  String get creatorId;
  @override
  UserModel get creator; // 간소화된 User 정보가 올 수 있음
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'location_type')
  LocationType get locationType;
  @override
  @JsonKey(name: 'location_lat')
  double? get locationLat;
  @override
  @JsonKey(name: 'location_lon')
  double? get locationLon;
  @override
  @JsonKey(name: 'location_name')
  String? get locationName;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;
  @override
  @JsonKey(name: 'max_participants')
  int get maxParticipants;
  @override
  @JsonKey(name: 'min_participants')
  int get minParticipants;
  @override
  @JsonKey(name: 'current_participants')
  int get currentParticipants;
  @override
  PartyStatus get status;
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm; // 목록 조회 시 포함
  @override
  List<PartyParticipantModel> get participants;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of PartyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyModelImplCopyWith<_$PartyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PartyParticipantModel _$PartyParticipantModelFromJson(
  Map<String, dynamic> json,
) {
  return _PartyParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$PartyParticipantModel {
  @JsonKey(name: 'participant_id')
  String get participantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; // joined, left
  @JsonKey(name: 'joined_at')
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this PartyParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyParticipantModelCopyWith<PartyParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyParticipantModelCopyWith<$Res> {
  factory $PartyParticipantModelCopyWith(
    PartyParticipantModel value,
    $Res Function(PartyParticipantModel) then,
  ) = _$PartyParticipantModelCopyWithImpl<$Res, PartyParticipantModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'participant_id') String participantId,
    @JsonKey(name: 'user_id') String userId,
    UserModel user,
    String status,
    @JsonKey(name: 'joined_at') DateTime joinedAt,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$PartyParticipantModelCopyWithImpl<
  $Res,
  $Val extends PartyParticipantModel
>
    implements $PartyParticipantModelCopyWith<$Res> {
  _$PartyParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participantId = null,
    Object? userId = null,
    Object? user = null,
    Object? status = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            participantId: null == participantId
                ? _value.participantId
                : participantId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PartyParticipantModelImplCopyWith<$Res>
    implements $PartyParticipantModelCopyWith<$Res> {
  factory _$$PartyParticipantModelImplCopyWith(
    _$PartyParticipantModelImpl value,
    $Res Function(_$PartyParticipantModelImpl) then,
  ) = __$$PartyParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'participant_id') String participantId,
    @JsonKey(name: 'user_id') String userId,
    UserModel user,
    String status,
    @JsonKey(name: 'joined_at') DateTime joinedAt,
  });

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$PartyParticipantModelImplCopyWithImpl<$Res>
    extends
        _$PartyParticipantModelCopyWithImpl<$Res, _$PartyParticipantModelImpl>
    implements _$$PartyParticipantModelImplCopyWith<$Res> {
  __$$PartyParticipantModelImplCopyWithImpl(
    _$PartyParticipantModelImpl _value,
    $Res Function(_$PartyParticipantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participantId = null,
    Object? userId = null,
    Object? user = null,
    Object? status = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$PartyParticipantModelImpl(
        participantId: null == participantId
            ? _value.participantId
            : participantId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyParticipantModelImpl implements _PartyParticipantModel {
  const _$PartyParticipantModelImpl({
    @JsonKey(name: 'participant_id') required this.participantId,
    @JsonKey(name: 'user_id') required this.userId,
    required this.user,
    required this.status,
    @JsonKey(name: 'joined_at') required this.joinedAt,
  });

  factory _$PartyParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyParticipantModelImplFromJson(json);

  @override
  @JsonKey(name: 'participant_id')
  final String participantId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final UserModel user;
  @override
  final String status;
  // joined, left
  @override
  @JsonKey(name: 'joined_at')
  final DateTime joinedAt;

  @override
  String toString() {
    return 'PartyParticipantModel(participantId: $participantId, userId: $userId, user: $user, status: $status, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyParticipantModelImpl &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, participantId, userId, user, status, joinedAt);

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyParticipantModelImplCopyWith<_$PartyParticipantModelImpl>
  get copyWith =>
      __$$PartyParticipantModelImplCopyWithImpl<_$PartyParticipantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyParticipantModelImplToJson(this);
  }
}

abstract class _PartyParticipantModel implements PartyParticipantModel {
  const factory _PartyParticipantModel({
    @JsonKey(name: 'participant_id') required final String participantId,
    @JsonKey(name: 'user_id') required final String userId,
    required final UserModel user,
    required final String status,
    @JsonKey(name: 'joined_at') required final DateTime joinedAt,
  }) = _$PartyParticipantModelImpl;

  factory _PartyParticipantModel.fromJson(Map<String, dynamic> json) =
      _$PartyParticipantModelImpl.fromJson;

  @override
  @JsonKey(name: 'participant_id')
  String get participantId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  UserModel get user;
  @override
  String get status; // joined, left
  @override
  @JsonKey(name: 'joined_at')
  DateTime get joinedAt;

  /// Create a copy of PartyParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyParticipantModelImplCopyWith<_$PartyParticipantModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
