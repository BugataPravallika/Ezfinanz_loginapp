import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ezfinanz/main.dart';

void main() {
  testWidgets('Onboarding flow advances through 3 slides to Welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EzFinanzApp());

    // Slide 1 checks
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Apply for a loan in minutes'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next -> Slide 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Track all your payments'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next -> Slide 3
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Safe and secure'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    // Tap "Get started" -> Welcome Screen
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Skip button navigates directly to Welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EzFinanzApp());

    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Onboarding uses animated page and button transitions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EzFinanzApp());

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
  });

  testWidgets('Back button navigates to previous slide', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EzFinanzApp());

    // Advance to Slide 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Track all your payments'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Verify returned to Slide 1
    expect(find.text('Apply for a loan in minutes'), findsOneWidget);
  });
}
