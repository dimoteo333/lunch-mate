import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mention Parsing Tests', () {
    // Match @mentions with alphanumeric, underscore, and Korean characters
    final RegExp mentionRegex = RegExp(r'@([a-zA-Z0-9_가-힣]+)');

    test('extracts single mention', () {
      final input = "Hello @JohnDoe";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@JohnDoe');
    });

    test('extracts multiple mentions', () {
      final input = "Hi @alice and @bob";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 2);
      expect(matches[0].group(0), '@alice');
      expect(matches[1].group(0), '@bob');
    });

    test('supports Korean characters in mentions', () {
      final input = "Hello @철수 and @영희";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 2);
      expect(matches[0].group(0), '@철수');
      expect(matches[1].group(0), '@영희');
    });

    test('does not match special characters after mention', () {
      final input = "Hello @JohnDoe!";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@JohnDoe'); // No trailing punctuation
    });

    test('no mentions return empty list', () {
      final input = "Just a regular test message without tags.";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.isEmpty, true);
    });
  });
}
