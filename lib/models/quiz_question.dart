class Question {
  final String categoryId;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  // Constructor use named parameters with required keyword to ensure that all fields are provided when creating a Question object.
  Question({
    required this.categoryId,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });
}