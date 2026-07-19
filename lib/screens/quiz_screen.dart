import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedAnswerIndex;
  int? _correctAnswerIndex;

  @override
  void initState() {
    super.initState();
    _questions = questions
        .where((question) => question.categoryId == widget.categoryId)
        .toList();
  }

  void _navigateToResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(score: _score, totalQuestions: _questions.length),
      ),
    );
  }

  void _goToNextQuestion() {
    if (!mounted) return;

    if (_currentQuestionIndex + 1 >= _questions.length) {
      _navigateToResultScreen();
      return;
    }

    setState(() {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
      _correctAnswerIndex = null;
    });
  }

  void checkAnswer(int selectedAnswerIndex) {
    if (_questions.isEmpty || _isAnswered) return;

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = selectedAnswerIndex == currentQuestion.correctAnswer;

    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = selectedAnswerIndex;
      _correctAnswerIndex = currentQuestion.correctAnswer;
      if (isCorrect) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _goToNextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Text(
            'No questions available for ${widget.categoryName}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_isAnswered)
              Text(
                _selectedAnswerIndex == _correctAnswerIndex
                    ? 'Correct!'
                    : 'Wrong!',
                style: TextStyle(
                  color: _selectedAnswerIndex == _correctAnswerIndex
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 12),
            ...currentQuestion.answers.asMap().entries.map((entry) {
              final answerIndex = entry.key;
              final answer = entry.value;
              final isCorrectAnswer = answerIndex == _correctAnswerIndex;
              final isSelectedAnswer = answerIndex == _selectedAnswerIndex;

              Color? backgroundColor;
              Color? textColor;

              if (_isAnswered) {
                if (isCorrectAnswer) {
                  backgroundColor = Colors.green.shade100;
                  textColor = Colors.green.shade800;
                } else if (isSelectedAnswer) {
                  backgroundColor = Colors.red.shade100;
                  textColor = Colors.red.shade800;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: _isAnswered ? null : () => checkAnswer(answerIndex),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${answerIndex + 1}. $answer',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor ?? Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
