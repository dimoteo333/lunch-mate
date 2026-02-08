import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';
import '../models/chat_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(dioProvider));
});

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Future<List<ChatMessageModel>> getMessages(String roomId) async {
    final response = await _dio.get('${ApiConstants.chat}/rooms/$roomId/messages');
    final List items = response.data;
    return items.map((json) => ChatMessageModel.fromJson(json)).toList();
  }
}
