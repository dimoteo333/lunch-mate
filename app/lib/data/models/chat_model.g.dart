// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageModelImpl _$$ChatMessageModelImplFromJson(
  Map<String, dynamic> json,
) => _$ChatMessageModelImpl(
  messageId: json['message_id'] as String?,
  roomId: json['room_id'] as String?,
  senderId: json['sender_id'] as String?,
  sender: json['sender'] == null
      ? null
      : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  type: json['type'] as String? ?? 'message',
);

Map<String, dynamic> _$$ChatMessageModelImplToJson(
  _$ChatMessageModelImpl instance,
) => <String, dynamic>{
  'message_id': instance.messageId,
  'room_id': instance.roomId,
  'sender_id': instance.senderId,
  'sender': instance.sender,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'type': instance.type,
};
