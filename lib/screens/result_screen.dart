import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:quiz_app/services/quiz_storage.dart';
import 'package:quiz_app/utils/color.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String quizName;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.quizName,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final result = QuizResult(
      quizName: widget.quizName,
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      time: DateTime.now(),
    );
    await QuizStorage.saveQuizResult(result);
  }

  @override
  Widget build(BuildContext context) {
    final maxScore = widget.totalQuestions * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.secondaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.score} / $maxScore',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: widget.score == maxScore
                    ? Colors.green
                    : Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.score == maxScore
                  ? 'Perfect! You got every answer right.'
                  : widget.score >= maxScore / 2
                  ? 'Great job! Keep it up.'
                  : 'Nice try! Practice more and improve.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
