import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    @JsonKey(name: 'message_id') String? messageId, // 서버에서 생성
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'sender_id') String? senderId,
    UserModel? sender,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('message') String type, // message, system
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
}
