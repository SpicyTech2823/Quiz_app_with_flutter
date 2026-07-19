import 'package:flutter/foundation.dart' hide Category;
import '../models/quiz_question.dart';
import '../models/category.dart';


final List<Category> categories = [
    Category(
      id: 'science',
      name: 'Science',
      image: 'assets/images/science.png',
    ),
    Category(
      id: 'history',
      name: 'History',
      image: 'assets/images/history.png',
    ),
    Category(
      id: 'geography',
      name: 'Geography',
      image: 'assets/images/geography.png',
    ),
];
List<Question> questions = [
  Question(
    categoryId: 'science',
    question: 'What is the chemical symbol for water?',
    answers: ['H2O', 'O2', 'CO2', 'NaCl'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'history',
    question: 'Who was the first President of the United States?',
    answers: ['George Washington', 'Thomas Jefferson', 'Abraham Lincoln', 'John Adams'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'geography',
    question: 'What is the capital of France?',
    answers: ['Paris', 'London', 'Berlin', 'Madrid'],
    correctAnswer: 0,
  ),
];