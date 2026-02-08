// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_domain')
  String get companyDomain => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_score')
  double get ratingScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_email_verified')
  bool get isEmailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'team_name')
  String? get teamName => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_title')
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'age_group')
  String? get ageGroup => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String>? get interests => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_lat')
  double? get companyLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_lon')
  double? get companyLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_lat')
  double? get homeLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_lon')
  double? get homeLon => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String email,
    @JsonKey(name: 'company_domain') String companyDomain,
    String nickname,
    @JsonKey(name: 'rating_score') double ratingScore,
    @JsonKey(name: 'is_email_verified') bool isEmailVerified,
    @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'team_name') String? teamName,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? gender,
    @JsonKey(name: 'age_group') String? ageGroup,
    String? bio,
    List<String>? interests,
    @JsonKey(name: 'company_lat') double? companyLat,
    @JsonKey(name: 'company_lon') double? companyLon,
    @JsonKey(name: 'home_lat') double? homeLat,
    @JsonKey(name: 'home_lon') double? homeLon,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? companyDomain = null,
    Object? nickname = null,
    Object? ratingScore = null,
    Object? isEmailVerified = null,
    Object? onboardingCompleted = null,
    Object? companyName = freezed,
    Object? teamName = freezed,
    Object? jobTitle = freezed,
    Object? gender = freezed,
    Object? ageGroup = freezed,
    Object? bio = freezed,
    Object? interests = freezed,
    Object? companyLat = freezed,
    Object? companyLon = freezed,
    Object? homeLat = freezed,
    Object? homeLon = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            companyDomain: null == companyDomain
                ? _value.companyDomain
                : companyDomain // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            ratingScore: null == ratingScore
                ? _value.ratingScore
                : ratingScore // ignore: cast_nullable_to_non_nullable
                      as double,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            onboardingCompleted: null == onboardingCompleted
                ? _value.onboardingCompleted
                : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            teamName: freezed == teamName
                ? _value.teamName
                : teamName // ignore: cast_nullable_to_non_nullable
                      as String?,
            jobTitle: freezed == jobTitle
                ? _value.jobTitle
                : jobTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            ageGroup: freezed == ageGroup
                ? _value.ageGroup
                : ageGroup // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            interests: freezed == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            companyLat: freezed == companyLat
                ? _value.companyLat
                : companyLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            companyLon: freezed == companyLon
                ? _value.companyLon
                : companyLon // ignore: cast_nullable_to_non_nullable
                      as double?,
            homeLat: freezed == homeLat
                ? _value.homeLat
                : homeLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            homeLon: freezed == homeLon
                ? _value.homeLon
                : homeLon // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String email,
    @JsonKey(name: 'company_domain') String companyDomain,
    String nickname,
    @JsonKey(name: 'rating_score') double ratingScore,
    @JsonKey(name: 'is_email_verified') bool isEmailVerified,
    @JsonKey(name: 'onboarding_completed') bool onboardingCompleted,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'team_name') String? teamName,
    @JsonKey(name: 'job_title') String? jobTitle,
    String? gender,
    @JsonKey(name: 'age_group') String? ageGroup,
    String? bio,
    List<String>? interests,
    @JsonKey(name: 'company_lat') double? companyLat,
    @JsonKey(name: 'company_lon') double? companyLon,
    @JsonKey(name: 'home_lat') double? homeLat,
    @JsonKey(name: 'home_lon') double? homeLon,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? companyDomain = null,
    Object? nickname = null,
    Object? ratingScore = null,
    Object? isEmailVerified = null,
    Object? onboardingCompleted = null,
    Object? companyName = freezed,
    Object? teamName = freezed,
    Object? jobTitle = freezed,
    Object? gender = freezed,
    Object? ageGroup = freezed,
    Object? bio = freezed,
    Object? interests = freezed,
    Object? companyLat = freezed,
    Object? companyLon = freezed,
    Object? homeLat = freezed,
    Object? homeLon = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        companyDomain: null == companyDomain
            ? _value.companyDomain
            : companyDomain // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        ratingScore: null == ratingScore
            ? _value.ratingScore
            : ratingScore // ignore: cast_nullable_to_non_nullable
                  as double,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        onboardingCompleted: null == onboardingCompleted
            ? _value.onboardingCompleted
            : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        teamName: freezed == teamName
            ? _value.teamName
            : teamName // ignore: cast_nullable_to_non_nullable
                  as String?,
        jobTitle: freezed == jobTitle
            ? _value.jobTitle
            : jobTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        ageGroup: freezed == ageGroup
            ? _value.ageGroup
            : ageGroup // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        interests: freezed == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        companyLat: freezed == companyLat
            ? _value.companyLat
            : companyLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        companyLon: freezed == companyLon
            ? _value.companyLon
            : companyLon // ignore: cast_nullable_to_non_nullable
                  as double?,
        homeLat: freezed == homeLat
            ? _value.homeLat
            : homeLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        homeLon: freezed == homeLon
            ? _value.homeLon
            : homeLon // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.email,
    @JsonKey(name: 'company_domain') required this.companyDomain,
    required this.nickname,
    @JsonKey(name: 'rating_score') required this.ratingScore,
    @JsonKey(name: 'is_email_verified') required this.isEmailVerified,
    @JsonKey(name: 'onboarding_completed') required this.onboardingCompleted,
    @JsonKey(name: 'company_name') this.companyName,
    @JsonKey(name: 'team_name') this.teamName,
    @JsonKey(name: 'job_title') this.jobTitle,
    this.gender,
    @JsonKey(name: 'age_group') this.ageGroup,
    this.bio,
    final List<String>? interests,
    @JsonKey(name: 'company_lat') this.companyLat,
    @JsonKey(name: 'company_lon') this.companyLon,
    @JsonKey(name: 'home_lat') this.homeLat,
    @JsonKey(name: 'home_lon') this.homeLon,
  }) : _interests = interests;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String email;
  @override
  @JsonKey(name: 'company_domain')
  final String companyDomain;
  @override
  final String nickname;
  @override
  @JsonKey(name: 'rating_score')
  final double ratingScore;
  @override
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @override
  @JsonKey(name: 'onboarding_completed')
  final bool onboardingCompleted;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'team_name')
  final String? teamName;
  @override
  @JsonKey(name: 'job_title')
  final String? jobTitle;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'age_group')
  final String? ageGroup;
  @override
  final String? bio;
  final List<String>? _interests;
  @override
  List<String>? get interests {
    final value = _interests;
    if (value == null) return null;
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'company_lat')
  final double? companyLat;
  @override
  @JsonKey(name: 'company_lon')
  final double? companyLon;
  @override
  @JsonKey(name: 'home_lat')
  final double? homeLat;
  @override
  @JsonKey(name: 'home_lon')
  final double? homeLon;

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, companyDomain: $companyDomain, nickname: $nickname, ratingScore: $ratingScore, isEmailVerified: $isEmailVerified, onboardingCompleted: $onboardingCompleted, companyName: $companyName, teamName: $teamName, jobTitle: $jobTitle, gender: $gender, ageGroup: $ageGroup, bio: $bio, interests: $interests, companyLat: $companyLat, companyLon: $companyLon, homeLat: $homeLat, homeLon: $homeLon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.companyDomain, companyDomain) ||
                other.companyDomain == companyDomain) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.ratingScore, ratingScore) ||
                other.ratingScore == ratingScore) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.ageGroup, ageGroup) ||
                other.ageGroup == ageGroup) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ) &&
            (identical(other.companyLat, companyLat) ||
                other.companyLat == companyLat) &&
            (identical(other.companyLon, companyLon) ||
                other.companyLon == companyLon) &&
            (identical(other.homeLat, homeLat) || other.homeLat == homeLat) &&
            (identical(other.homeLon, homeLon) || other.homeLon == homeLon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    email,
    companyDomain,
    nickname,
    ratingScore,
    isEmailVerified,
    onboardingCompleted,
    companyName,
    teamName,
    jobTitle,
    gender,
    ageGroup,
    bio,
    const DeepCollectionEquality().hash(_interests),
    companyLat,
    companyLon,
    homeLat,
    homeLon,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    @JsonKey(name: 'user_id') required final String userId,
    required final String email,
    @JsonKey(name: 'company_domain') required final String companyDomain,
    required final String nickname,
    @JsonKey(name: 'rating_score') required final double ratingScore,
    @JsonKey(name: 'is_email_verified') required final bool isEmailVerified,
    @JsonKey(name: 'onboarding_completed')
    required final bool onboardingCompleted,
    @JsonKey(name: 'company_name') final String? companyName,
    @JsonKey(name: 'team_name') final String? teamName,
    @JsonKey(name: 'job_title') final String? jobTitle,
    final String? gender,
    @JsonKey(name: 'age_group') final String? ageGroup,
    final String? bio,
    final List<String>? interests,
    @JsonKey(name: 'company_lat') final double? companyLat,
    @JsonKey(name: 'company_lon') final double? companyLon,
    @JsonKey(name: 'home_lat') final double? homeLat,
    @JsonKey(name: 'home_lon') final double? homeLon,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get email;
  @override
  @JsonKey(name: 'company_domain')
  String get companyDomain;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'rating_score')
  double get ratingScore;
  @override
  @JsonKey(name: 'is_email_verified')
  bool get isEmailVerified;
  @override
  @JsonKey(name: 'onboarding_completed')
  bool get onboardingCompleted;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'team_name')
  String? get teamName;
  @override
  @JsonKey(name: 'job_title')
  String? get jobTitle;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'age_group')
  String? get ageGroup;
  @override
  String? get bio;
  @override
  List<String>? get interests;
  @override
  @JsonKey(name: 'company_lat')
  double? get companyLat;
  @override
  @JsonKey(name: 'company_lon')
  double? get companyLon;
  @override
  @JsonKey(name: 'home_lat')
  double? get homeLat;
  @override
  @JsonKey(name: 'home_lon')
  double? get homeLon;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
