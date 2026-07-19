import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_app/screens/home.dart';

void main() {
  testWidgets('tapping a category shows its questions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));

    await tester.tap(find.text('Science'));
    await tester.pumpAndSettle();

    expect(find.text('What is the chemical symbol for water?'), findsOneWidget);
    expect(
      find.text('Who was the first President of the United States?'),
      findsNothing,
    );
  });

  testWidgets('selecting an answer shows feedback and finishes the quiz', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));

    await tester.tap(find.text('Science'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1. H2O'));
    await tester.pump();

    expect(find.text('Correct!'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Quiz Result'), findsOneWidget);
  });

  testWidgets('search filters the category list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));

    await tester.enterText(find.byType(TextField), 'his');
    await tester.pump();

    expect(find.text('History'), findsOneWidget);
    expect(find.text('Science'), findsNothing);
  });
}
