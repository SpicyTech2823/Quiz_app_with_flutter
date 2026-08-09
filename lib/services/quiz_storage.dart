import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_result.dart';

class QuizStorage {
  static const String _quizResultsKey = 'quiz_results';
  
  // Save a quiz result to local storage
  static Future<void> saveQuizResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList(_quizResultsKey) ?? [];
    results.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_quizResultsKey, results);
  }

  // Retrieve all quiz results from local storage
  static Future<List<QuizResult>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList(_quizResultsKey) ?? [];
    return results
        .map((result) => QuizResult.fromJson(jsonDecode(result)))
        .toList();
  }
  // Clear all quiz results from local storage
  static Future<void> clearQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_quizResultsKey);
  }
}
