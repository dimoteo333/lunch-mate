// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return _ChatMessageModel.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageModel {
  @JsonKey(name: 'message_id')
  String? get messageId => throw _privateConstructorUsedError; // 서버에서 생성
  @JsonKey(name: 'room_id')
  String? get roomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  String? get senderId => throw _privateConstructorUsedError;
  UserModel? get sender => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
    ChatMessageModel value,
    $Res Function(ChatMessageModel) then,
  ) = _$ChatMessageModelCopyWithImpl<$Res, ChatMessageModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'message_id') String? messageId,
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'sender_id') String? senderId,
    UserModel? sender,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String type,
  });

  $UserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res, $Val extends ChatMessageModel>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = freezed,
    Object? roomId = freezed,
    Object? senderId = freezed,
    Object? sender = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            messageId: freezed == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            roomId: freezed == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderId: freezed == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sender: freezed == sender
                ? _value.sender
                : sender // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageModelImplCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$$ChatMessageModelImplCopyWith(
    _$ChatMessageModelImpl value,
    $Res Function(_$ChatMessageModelImpl) then,
  ) = __$$ChatMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'message_id') String? messageId,
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'sender_id') String? senderId,
    UserModel? sender,
    String content,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String type,
  });

  @override
  $UserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$ChatMessageModelImplCopyWithImpl<$Res>
    extends _$ChatMessageModelCopyWithImpl<$Res, _$ChatMessageModelImpl>
    implements _$$ChatMessageModelImplCopyWith<$Res> {
  __$$ChatMessageModelImplCopyWithImpl(
    _$ChatMessageModelImpl _value,
    $Res Function(_$ChatMessageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = freezed,
    Object? roomId = freezed,
    Object? senderId = freezed,
    Object? sender = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      _$ChatMessageModelImpl(
        messageId: freezed == messageId
            ? _value.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        roomId: freezed == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderId: freezed == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sender: freezed == sender
            ? _value.sender
            : sender // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageModelImpl implements _ChatMessageModel {
  const _$ChatMessageModelImpl({
    @JsonKey(name: 'message_id') this.messageId,
    @JsonKey(name: 'room_id') this.roomId,
    @JsonKey(name: 'sender_id') this.senderId,
    this.sender,
    required this.content,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.type = 'message',
  });

  factory _$ChatMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageModelImplFromJson(json);

  @override
  @JsonKey(name: 'message_id')
  final String? messageId;
  // 서버에서 생성
  @override
  @JsonKey(name: 'room_id')
  final String? roomId;
  @override
  @JsonKey(name: 'sender_id')
  final String? senderId;
  @override
  final UserModel? sender;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'ChatMessageModel(messageId: $messageId, roomId: $roomId, senderId: $senderId, sender: $sender, content: $content, createdAt: $createdAt, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageModelImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageId,
    roomId,
    senderId,
    sender,
    content,
    createdAt,
    type,
  );

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      __$$ChatMessageModelImplCopyWithImpl<_$ChatMessageModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageModelImplToJson(this);
  }
}

abstract class _ChatMessageModel implements ChatMessageModel {
  const factory _ChatMessageModel({
    @JsonKey(name: 'message_id') final String? messageId,
    @JsonKey(name: 'room_id') final String? roomId,
    @JsonKey(name: 'sender_id') final String? senderId,
    final UserModel? sender,
    required final String content,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final String type,
  }) = _$ChatMessageModelImpl;

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$ChatMessageModelImpl.fromJson;

  @override
  @JsonKey(name: 'message_id')
  String? get messageId; // 서버에서 생성
  @override
  @JsonKey(name: 'room_id')
  String? get roomId;
  @override
  @JsonKey(name: 'sender_id')
  String? get senderId;
  @override
  UserModel? get sender;
  @override
  String get content;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  String get type;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
