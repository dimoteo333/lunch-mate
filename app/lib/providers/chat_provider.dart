import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app/core/constants/api_constants.dart';
import 'package:app/data/models/chat_model.dart';
import 'package:app/data/repositories/chat_repository.dart';
import 'package:app/data/providers/storage_provider.dart';

// 메시지 리스트 상태
class ChatState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 채팅방 ID별로 상태 관리 (Family)
final chatProvider = StateNotifierProvider.family.autoDispose<ChatNotifier, ChatState, String>((ref, roomId) {
  return ChatNotifier(
    ref.read(chatRepositoryProvider),
    ref,
    roomId,
  );
});

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final Ref _ref;
  final String roomId;
  
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  ChatNotifier(this._repository, this._ref, this.roomId) : super(ChatState()) {
    _init();
  }

  Future<void> _init() async {
    await loadMessages();
    await connectWebSocket();
  }

  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true);
    try {
      final messages = await _repository.getMessages(roomId);
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> connectWebSocket() async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');
    
    if (token == null) return;

    // ws://127.0.0.1:8000/ws/chat/{roomId}?token={token}
    // ApiConstants.baseUrl에서 host 추출
    final uri = Uri.parse(ApiConstants.baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final wsUrl = '$wsScheme://${uri.host}:${uri.port}/ws/chat/$roomId?token=$token';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _subscription = _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          // 내 메시지는 이미 로컬에 추가했을 수 있으므로 중복 체크 필요하거나,
          // 서버 응답으로 확정된 메시지로 교체하는 로직이 필요함.
          // 여기서는 간단히 모든 메시지를 추가.
          
          if (data['type'] == 'message' || data['type'] == 'system') {
            final chatMessage = ChatMessageModel.fromJson(data);
            addMessage(chatMessage);
          }
        },
        onError: (error) {
          // 재연결 로직 등 필요
          debugPrint('WebSocket Error: $error');
        },
      );
    } catch (e) {
      debugPrint('WebSocket Connection Failed: $e');
    }
  }

  void sendMessage(String content) {
    if (content.isEmpty) return;

    final message = {
      'type': 'message',
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _channel?.sink.add(jsonEncode(message));
    
    // 낙관적 업데이트 (Optimistic Update)
    // 실제로는 서버 응답(echo)을 기다리는 것이 더 안전할 수 있음.
    // 여기서는 서버가 보낸 메시지를 수신해서 처리하므로 로컬 추가 생략 가능하지만,
    // UX 반응성을 위해 로컬에 먼저 추가할 수도 있음. (지금은 생략)
  }

  void addMessage(ChatMessageModel message) {
    state = state.copyWith(
      messages: [message, ...state.messages], // 최신 메시지가 위로 오게 (역순 리스트뷰 가정)
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
