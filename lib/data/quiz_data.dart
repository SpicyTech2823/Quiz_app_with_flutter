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
    categoryId: 'science',
    question: 'What planet is known as the Red Planet?',
    answers: ['Mars', 'Venus', 'Jupiter', 'Saturn'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'science',
    question: 'What is the speed of light?',
    answers: ['299,792 km/s', '150,000 km/s', '1,000 km/s', '3,000 km/s'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'science',
    question: 'What is the powerhouse of the cell?',
    answers: ['Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic Reticulum'],
    correctAnswer: 1,
  ),
  Question(
    categoryId: 'history',
    question: 'Who was the first President of the United States?',
    answers: ['George Washington', 'Thomas Jefferson', 'Abraham Lincoln', 'John Adams'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'history',
    question: 'Who wrote the Declaration of Independence?',
    answers: ['Thomas Jefferson', 'Benjamin Franklin', 'John Adams', 'James Madison'],
    correctAnswer: 0,
  ),
  Question(
    categoryId: 'history',
    question: 'Where did the Industrial Revolution begin?',
    answers: ['France','Germany','England', 'United States'],
    correctAnswer: 2,
  ),
  Question(
    categoryId: 'geography',
    question: 'What is the capital of France?',
    answers: ['Phnom Penh', 'London', 'Berlin', 'Paris'],
    correctAnswer: 3,
  ),
  Question(
    categoryId: 'geography',
    question: 'Which continent is the Sahara Desert located in?',
    answers: ['Asia', 'Africa', 'Australia', 'South America'],
    correctAnswer: 1,
  ),
  Question(
    categoryId: 'geography',
    question: 'What is the largest ocean on Earth?',
    answers: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
    correctAnswer: 3,
  ),
];