import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final maxScore = totalQuestions * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        backgroundColor: Colors.deepPurple,
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
              '$score / $maxScore',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: score == maxScore ? Colors.green : Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              score == maxScore
                  ? 'Perfect! You got every answer right.'
                  : score >= maxScore / 2
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
