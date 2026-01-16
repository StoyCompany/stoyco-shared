import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_shared/core/ui/atoms/custom_text.dart';

void main() {
  testWidgets('CustomText widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomText('Hello, World!', style: TextStyle(fontSize: 20)),
        ),
      ),
    );

    // Verify that our CustomText widget displays the correct text.
    expect(find.text('Hello, World!'), findsOneWidget);

    // Verify that the text has the correct style.
    final textWidget = tester.widget<Text>(find.text('Hello, World!'));
    expect(textWidget.style?.fontSize, 20);
  });
}
