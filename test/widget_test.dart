// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:smart_reader/main.dart';

void main() {
  testWidgets('App loads and shows SmartBook title', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Đợi tất cả animations và async operations hoàn thành
    // (BLoC cần thời gian để emit HomeLoaded state)
    await tester.pumpAndSettle();

    // Verify that the app title "SmartBook" is present in the AppBar
    expect(find.text('SmartBook'), findsOneWidget);
  });
}
