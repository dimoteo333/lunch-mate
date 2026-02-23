// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_brief_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserBriefModel _$UserBriefModelFromJson(Map<String, dynamic> json) {
  return _UserBriefModel.fromJson(json);
}

/// @nodoc
mixin _$UserBriefModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_score')
  double get ratingScore => throw _privateConstructorUsedError;

  /// Serializes this UserBriefModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBriefModelCopyWith<UserBriefModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBriefModelCopyWith<$Res> {
  factory $UserBriefModelCopyWith(
    UserBriefModel value,
    $Res Function(UserBriefModel) then,
  ) = _$UserBriefModelCopyWithImpl<$Res, UserBriefModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String nickname,
    @JsonKey(name: 'rating_score') double ratingScore,
  });
}

/// @nodoc
class _$UserBriefModelCopyWithImpl<$Res, $Val extends UserBriefModel>
    implements $UserBriefModelCopyWith<$Res> {
  _$UserBriefModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? ratingScore = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            ratingScore: null == ratingScore
                ? _value.ratingScore
                : ratingScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserBriefModelImplCopyWith<$Res>
    implements $UserBriefModelCopyWith<$Res> {
  factory _$$UserBriefModelImplCopyWith(
    _$UserBriefModelImpl value,
    $Res Function(_$UserBriefModelImpl) then,
  ) = __$$UserBriefModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    String nickname,
    @JsonKey(name: 'rating_score') double ratingScore,
  });
}

/// @nodoc
class __$$UserBriefModelImplCopyWithImpl<$Res>
    extends _$UserBriefModelCopyWithImpl<$Res, _$UserBriefModelImpl>
    implements _$$UserBriefModelImplCopyWith<$Res> {
  __$$UserBriefModelImplCopyWithImpl(
    _$UserBriefModelImpl _value,
    $Res Function(_$UserBriefModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? ratingScore = null,
  }) {
    return _then(
      _$UserBriefModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        ratingScore: null == ratingScore
            ? _value.ratingScore
            : ratingScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBriefModelImpl implements _UserBriefModel {
  const _$UserBriefModelImpl({
    @JsonKey(name: 'user_id') required this.userId,
    required this.nickname,
    @JsonKey(name: 'rating_score') required this.ratingScore,
  });

  factory _$UserBriefModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBriefModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String nickname;
  @override
  @JsonKey(name: 'rating_score')
  final double ratingScore;

  @override
  String toString() {
    return 'UserBriefModel(userId: $userId, nickname: $nickname, ratingScore: $ratingScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBriefModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.ratingScore, ratingScore) ||
                other.ratingScore == ratingScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, nickname, ratingScore);

  /// Create a copy of UserBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBriefModelImplCopyWith<_$UserBriefModelImpl> get copyWith =>
      __$$UserBriefModelImplCopyWithImpl<_$UserBriefModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBriefModelImplToJson(this);
  }
}

abstract class _UserBriefModel implements UserBriefModel {
  const factory _UserBriefModel({
    @JsonKey(name: 'user_id') required final String userId,
    required final String nickname,
    @JsonKey(name: 'rating_score') required final double ratingScore,
  }) = _$UserBriefModelImpl;

  factory _UserBriefModel.fromJson(Map<String, dynamic> json) =
      _$UserBriefModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'rating_score')
  double get ratingScore;

  /// Create a copy of UserBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBriefModelImplCopyWith<_$UserBriefModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
