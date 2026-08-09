class QuizResult {
  final String quizName;
  final int score;
  final int totalQuestions;
  final DateTime time;
  QuizResult({
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.time,
  });
  // convert the QuizResult to a map for storage or API requests
  Map<String, dynamic> toJson() {
    return {
      'quizName': quizName,
      'score': score,
      'totalQuestions': totalQuestions,
      'time': time.toIso8601String(),
    };
  }

  // create a QuizResult from a map (e.g., from storage or API response)
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizName: json['quizName'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      time: DateTime.parse(json['time']),
    );
  }

  String get category => quizName;

  DateTime get date => time;
}
