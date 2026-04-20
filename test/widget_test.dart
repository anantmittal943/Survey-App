// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey_app/main.dart';

void main() {
  testWidgets(
      'shows onboarding then opens survey form', (WidgetTester tester) async {
    await tester.pumpWidget(const SurveyApp());

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    expect(find.text('Expand Your\nKnowledge !'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Customer Feedback Survey'), findsOneWidget);
    expect(find.text('Tell us about your experience'), findsOneWidget);
  });
}
