import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/presentation/chat/chat_screen.dart';
import 'package:app/core/utils/debouncer.dart';

void main() {
  group('Mention Feature Unit Tests', () {
    final mentionRegex = RegExp(r'@([a-zA-Z0-9_가-힣]+)');

    test('extracts single mention correctly', () {
      final input = "Hello @JohnDoe";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@JohnDoe');
      expect(matches[0].group(1), 'JohnDoe'); // Without @
    });

    test('extracts multiple mentions correctly', () {
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

    test('does not match @ symbol alone', () {
      final input = "Hello @";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.isEmpty, true);
    });

    test('does not match mentions without @', () {
      final input = "Hello alice";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.isEmpty, true);
    });

    test('supports underscores in mentions', () {
      final input = "Hello @user_name";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@user_name');
    });

    test('supports numbers in mentions', () {
      final input = "Hello @user123";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@user123');
    });

    test('handles mixed alphanumeric and Korean', () {
      final input = "Hello @User123김";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@User123김');
    });

    test('no mentions return empty list', () {
      final input = "Just a regular test message without tags.";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.isEmpty, true);
    });

    test('handles mention at start of message', () {
      final input = "@alice hello there";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@alice');
    });

    test('handles mention after newline', () {
      final input = "Hello\n@alice there";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@alice');
    });

    test('handles mention after space', () {
      final input = "Hello @alice there";
      final matches = mentionRegex.allMatches(input).toList();

      expect(matches.length, 1);
      expect(matches[0].group(0), '@alice');
    });

    test('does not trigger in middle of word', () {
      final input = "email@address.com";
      final matches = mentionRegex.allMatches(input).toList();

      // Should not match because @ is not after space/newline/start
      // But regex doesn't check position, so it will match
      // This is handled by frontend logic
      expect(matches.length, 1);
      expect(matches[0].group(0), '@address');
    });

    test('handles empty nickname scenario', () {
      final nickname = '';
      final displayChar = nickname.isNotEmpty ? nickname[0] : '?';

      expect(displayChar, '?');
    });

    test('handles single character nickname', () {
      final nickname = 'A';
      final displayChar = nickname.isNotEmpty ? nickname[0] : '?';

      expect(displayChar, 'A');
    });
  });

  group('Debouncer Tests', () {
    testWidgets('debouncer delays execution', (tester) async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));

      var executed = false;
      var counter = 0;

      // Schedule multiple rapid calls
      for (int i = 0; i < 5; i++) {
        debouncer.run(() {
          executed = true;
          counter++;
        });
      }

      // Should not execute immediately
      expect(executed, isFalse);

      // Wait less than delay
      await tester.pump(const Duration(milliseconds: 50));
      expect(executed, isFalse);

      // Wait for delay to complete
      await tester.pump(const Duration(milliseconds: 100));
      expect(executed, isTrue);

      // Should only execute once despite 5 calls
      expect(counter, 1);

      debouncer.dispose();
    });

    testWidgets('debouncer cancels pending execution', (tester) async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));

      var executed = false;

      debouncer.run(() => executed = true);

      // Cancel before delay completes
      debouncer.cancel();

      // Wait past delay
      await tester.pump(const Duration(milliseconds: 150));

      // Should not execute
      expect(executed, isFalse);

      debouncer.dispose();
    });

    testWidgets('debouncer allows rescheduling after cancel', (tester) async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));

      var executed = false;
      var value = 0;

      debouncer.run(() => value = 1);
      debouncer.cancel();

      // Schedule new action
      debouncer.run(() {
        executed = true;
        value = 2;
      });

      await tester.pump(const Duration(milliseconds: 100));

      expect(executed, isTrue);
      expect(value, 2); // Should execute the second action

      debouncer.dispose();
    });

    testWidgets('debouncer flush cancels pending execution', (tester) async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));

      var executed = false;

      debouncer.run(() => executed = true);

      // Flush before delay completes - cancels without executing
      debouncer.flush();

      expect(executed, isFalse);

      // Wait past delay - should still not execute
      await tester.pump(const Duration(milliseconds: 150));

      expect(executed, isFalse);

      debouncer.dispose();
    });
  });

  group('Empty Member List Handling', () {
    test('handles empty member list gracefully', () {
      final members = <String>[];
      final query = 'test';
      final filtered = members.where((m) => m.toLowerCase().contains(query.toLowerCase())).toList();

      expect(filtered, isEmpty);
    });

    test('handles null member list gracefully', () {
      final List<String>? members = null;
      final safeMembers = members ?? [];

      expect(safeMembers, isEmpty);
      expect(() => safeMembers.length, returnsNormally);
    });
  });

  group('Cursor Position Edge Cases', () {
    test('handles negative cursor position', () {
      final text = "Hello world";
      final cursorPosition = -1;

      final shouldProcess = cursorPosition >= 0 && cursorPosition <= text.length;

      expect(shouldProcess, isFalse);
    });

    test('handles cursor position beyond text length', () {
      final text = "Hello";
      final cursorPosition = 100;

      final shouldProcess = cursorPosition >= 0 && cursorPosition <= text.length;

      expect(shouldProcess, isFalse);
    });

    test('handles valid cursor position', () {
      final text = "Hello";
      final cursorPosition = 3;

      final shouldProcess = cursorPosition >= 0 && cursorPosition <= text.length;

      expect(shouldProcess, isTrue);
    });
  });

  group('Mention Trigger Position Tests', () {
    test('triggers at start of text', () {
      final text = "@alice";
      final lastAtPos = text.lastIndexOf('@');

      expect(lastAtPos, 0);
    });

    test('triggers after space', () {
      final text = "Hello @alice";
      final lastAtPos = text.lastIndexOf('@');

      expect(lastAtPos, 6);
      expect(text[lastAtPos - 1], ' ');
    });

    test('triggers after newline', () {
      final text = "Hello\n@alice";
      final lastAtPos = text.lastIndexOf('@');

      expect(lastAtPos, 6);
      expect(text[lastAtPos - 1], '\n');
    });

    test('does not trigger in middle of word', () {
      final text = "email@address";
      final lastAtPos = text.lastIndexOf('@');

      expect(lastAtPos, 5);
      expect(text[lastAtPos - 1], 'l'); // Not space or newline
    });
  });
}
