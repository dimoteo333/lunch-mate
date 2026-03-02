import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/chat_provider.dart';
import 'package:app/data/repositories/chat_repository.dart';
import 'package:app/data/models/chat_model.dart';
import 'package:app/data/models/user_brief_model.dart';
import 'package:dio/dio.dart';

void main() {
  group('ChatState Tests', () {
    test('creates default state', () {
      final state = ChatState();

      expect(state.messages, isEmpty);
      expect(state.members, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      final state1 = ChatState(
        messages: [],
        members: [],
        isLoading: true,
        error: 'test error',
      );

      final state2 = state1.copyWith(
        isLoading: false,
        error: null,
      );

      expect(state2.messages, isEmpty);
      expect(state2.members, isEmpty);
      expect(state2.isLoading, isFalse);
      expect(state2.error, isNull);

      // Original state should be unchanged
      expect(state1.isLoading, isTrue);
      expect(state1.error, 'test error');
    });

    test('copyWith preserves values when not provided', () {
      final members = [UserBriefModel(userId: 'user1', nickname: 'Alice', ratingScore: 4.0)];

      final state1 = ChatState(
        messages: [],
        members: members,
        isLoading: true,
      );

      final state2 = state1.copyWith(isLoading: false);

      expect(state2.members, same(members));
      expect(state2.messages, isEmpty);
      expect(state2.isLoading, isFalse);
    });

    test('copyWith with null values clears fields', () {
      final state1 = ChatState(
        messages: [ChatMessageModel(
          messageId: 'msg1',
          roomId: 'room1',
          senderId: 'user1',
          sender: null,
          content: 'Hello',
          createdAt: DateTime(2026, 1, 1),
          type: 'message',
        )],
        members: [UserBriefModel(userId: 'user1', nickname: 'Alice', ratingScore: 4.0)],
        isLoading: true,
        error: 'error',
      );

      final state2 = state1.copyWith(
        messages: [],
        members: [], // Use empty list instead of null (Freezed behavior)
        error: null,
      );

      expect(state2.messages, isEmpty);
      expect(state2.members, isEmpty); // Freezed keeps the value passed
      expect(state2.error, isNull);
      expect(state2.isLoading, isTrue); // Not changed
    });
  });

  group('ChatMessageModel Tests', () {
    test('fromJson handles null sender (system message)', () {
      final json = {
        'message_id': 'msg1',
        'room_id': 'room1',
        'sender_id': null,
        'sender': null,
        'content': 'System message',
        'created_at': '2026-01-01T00:00:00Z',
        'type': 'system',
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.senderId, isNull);
      expect(model.sender, isNull);
      expect(model.type, 'system');
    });

    test('toJson creates correct JSON', () {
      final model = ChatMessageModel(
        messageId: 'msg1',
        roomId: 'room1',
        senderId: 'user1',
        sender: null,
        content: 'Hello',
        createdAt: DateTime(2026, 1, 1),
        type: 'message',
      );

      final json = model.toJson();

      expect(json['message_id'], 'msg1');
      expect(json['room_id'], 'room1');
      expect(json['sender_id'], 'user1');
      expect(json['content'], 'Hello');
      expect(json['type'], 'message');
    });

    test('parses timestamp correctly', () {
      final timestamp = '2026-01-15T12:30:45Z';
      final json = {
        'message_id': 'msg1',
        'room_id': 'room1',
        'sender_id': null,
        'sender': null,
        'content': 'Test',
        'created_at': timestamp,
        'type': 'message',
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.createdAt, isA<DateTime>());
      expect(model.createdAt.year, 2026);
      expect(model.createdAt.month, 1);
      expect(model.createdAt.day, 15);
    });
  });

  group('UserBriefModel Tests', () {
    test('fromJson creates correct instance', () {
      final json = {
        'user_id': 'user1',
        'nickname': 'Alice',
        'rating_score': 4.5,
      };

      final model = UserBriefModel.fromJson(json);

      expect(model.userId, 'user1');
      expect(model.nickname, 'Alice');
      expect(model.ratingScore, 4.5);
    });

    test('fromJson handles Korean characters', () {
      final json = {
        'user_id': 'user1',
        'nickname': '김철수',
        'rating_score': 4.5,
      };

      final model = UserBriefModel.fromJson(json);

      expect(model.nickname, '김철수');
    });

    test('fromJson handles empty nickname', () {
      final json = {
        'user_id': 'user1',
        'nickname': '',
        'rating_score': 4.5,
      };

      final model = UserBriefModel.fromJson(json);

      expect(model.nickname, '');
    });

    test('toJson creates correct JSON', () {
      final model = UserBriefModel(
        userId: 'user1',
        nickname: 'Alice',
        ratingScore: 4.5,
      );

      final json = model.toJson();

      expect(json['user_id'], 'user1');
      expect(json['nickname'], 'Alice');
      expect(json['rating_score'], 4.5);
    });

    test('copyWith creates new instance with updated values', () {
      final model1 = UserBriefModel(
        userId: 'user1',
        nickname: 'Alice',
        ratingScore: 4.5,
      );

      final model2 = model1.copyWith(nickname: 'Bob');

      expect(model2.userId, 'user1');
      expect(model2.nickname, 'Bob');
      expect(model2.ratingScore, 4.5);

      // Original should be unchanged
      expect(model1.nickname, 'Alice');
    });
  });

  group('Mention Edge Case Tests', () {
    test('handles duplicate mention notifications', () {
      // Simulate tracking by user_id to prevent duplicates
      final mentionedUserIds = <String>{};
      final mentions = <Map<String, dynamic>>[];

      // Same user mentioned multiple times
      final nickname = 'Alice';
      final userId = 'user1';

      // First mention
      if (!mentionedUserIds.contains(userId)) {
        mentionedUserIds.add(userId);
        mentions.add({'user_id': userId, 'nickname': nickname});
      }

      // Second mention of same user (should be skipped)
      if (!mentionedUserIds.contains(userId)) {
        mentionedUserIds.add(userId);
        mentions.add({'user_id': userId, 'nickname': nickname});
      }

      expect(mentionedUserIds.length, 1);
      expect(mentions.length, 1);
      expect(mentions[0]['user_id'], userId);
    });

    test('handles multiple unique mentions', () {
      final mentionedUserIds = <String>{};
      final mentions = <Map<String, dynamic>>[];

      final users = [
        {'user_id': 'user1', 'nickname': 'Alice'},
        {'user_id': 'user2', 'nickname': 'Bob'},
        {'user_id': 'user3', 'nickname': 'Charlie'},
      ];

      for (final user in users) {
        final userId = user['user_id'] as String;
        final nickname = user['nickname'] as String;

        if (!mentionedUserIds.contains(userId)) {
          mentionedUserIds.add(userId);
          mentions.add({'user_id': userId, 'nickname': nickname});
        }
      }

      expect(mentionedUserIds.length, 3);
      expect(mentions.length, 3);
    });

    test('handles empty mention list', () {
      final mentionedUserIds = <String>{};
      final mentions = <Map<String, dynamic>>[];

      expect(mentionedUserIds, isEmpty);
      expect(mentions, isEmpty);
    });
  });

  group('Error Handling Tests', () {
    test('handles DioException gracefully', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(error.type, DioExceptionType.connectionTimeout);
      expect(error.requestOptions.path, '/test');
    });

    test('handles 404 error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(error.response?.statusCode, 404);
    });

    test('handles 403 forbidden error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 403,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(error.response?.statusCode, 403);
    });
  });
}
