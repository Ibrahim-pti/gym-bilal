import 'package:flutter_test/flutter_test.dart';
import 'package:gym_base/main.dart';

void main() {
  testWidgets('GymBaseApp launches smoothly test', (WidgetTester tester) async {
    await tester.pumpWidget(const GymBaseApp());
    expect(find.text('GYM BASE'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
