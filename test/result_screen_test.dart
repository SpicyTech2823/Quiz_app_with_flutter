import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/quiz_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saving a result adds it to archive storage', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const MaterialApp(
        home: ResultScreen(score: 20, totalQuestions: 2, quizName: 'Science'),
      ),
    );
    await tester.pumpAndSettle();

    final results = await QuizStorage.getQuizResults();
    expect(results, hasLength(1));
    expect(results.first.quizName, 'Science');
    expect(results.first.score, 20);
    expect(results.first.totalQuestions, 2);
  });
}
