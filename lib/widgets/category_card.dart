import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import '../models/category.dart' as category_model;

class Category extends StatelessWidget {
  final List<category_model.Category> categories;

  const Category({super.key, required this.categories});

  final List<Color> _colors = const [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.cyan,
  ];

  Color _getCategoryColor(int index, category_model.Category category) {
    if (category.color != null) {
      return category.color!;
    }
    return _colors[index % _colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  categoryId: category.id,
                  categoryName: category.name,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _getCategoryColor(index, category),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (category.icon != null)
                    Expanded(
                      child: Icon(
                        category.icon,
                        size: 64,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(Icons.quiz, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
