import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home.dart';
import 'package:quiz_app/utils/color.dart';
import '../models/quiz_result.dart';
import '../services/quiz_storage.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  // store all quiz results in a list
  List<QuizResult> _quizResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizResults();
  }

  Future<void> _loadQuizResults() async {
    // get all quiz results from local storage
    final results = await QuizStorage.getQuizResults();
    setState(() {
      _quizResults = results;
      _isLoading = false;
    });
  }

  Future<void> _clearQuizResults() async {
    // clear all quiz results from local storage
    await QuizStorage.clearQuizResults();
    setState(() {
      _quizResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.secondaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),

          // Navigate back to the home screen
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _clearQuizResults();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quizResults.isEmpty
          ? const Center(
              child: Text(
                'No quiz results found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _quizResults.length,
              itemBuilder: (context, index) {
                final result = _quizResults[index];
                return ListTile(
                  title: Text(result.category),
                  subtitle: Text(
                    'Score: ${result.score} / ${result.totalQuestions * 10}',
                  ),
                  trailing: Text(
                    '${result.date.toLocal().toString().split('.')[0]}',
                  ),
                );
              },
            ),
    );
  }
}
