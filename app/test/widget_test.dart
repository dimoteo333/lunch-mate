import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/app.dart';

void main() {
  testWidgets('App starts with Login Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LunchMateApp()));

    // Verify that Login Screen is shown.
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
