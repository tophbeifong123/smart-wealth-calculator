// This is a widget test for Smart Wealth Calculator.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_wealth_calculator/main.dart';
import 'package:smart_wealth_calculator/features/calculator/presentation/widgets/custom_card.dart';

void main() {
  testWidgets('App renders dashboard and widgets correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is displayed.
    expect(find.text('Smart Wealth Calculator'), findsOneWidget);

    // Verify that tab bars are displayed.
    expect(find.text('ดอกเบี้ยทบต้น'), findsOneWidget);
    expect(find.text('เป้าหมายออม'), findsOneWidget);
    expect(find.text('วางแผนเกษียณ'), findsOneWidget);
  });

  testWidgets('CustomCard interacts correctly', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Tap Me'),
          ),
        ),
      ),
    );

    expect(find.text('Tap Me'), findsOneWidget);
    await tester.tap(find.text('Tap Me'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
