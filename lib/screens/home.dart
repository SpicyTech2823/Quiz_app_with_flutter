import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/category_card.dart';
import 'package:quiz_app/utils/color.dart';
import '../data/quiz_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((category) {
      final query = _searchText.toLowerCase();
      final name = category.name.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: MyColors.secondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            // User avatar image
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // Greeting + name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Welcome back,',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    'John',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert, color: Colors.white),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')),
              );
            },
          ),
        ],
      ),
      //Search category
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredCategories.isEmpty
                ? const Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Category(categories: filteredCategories),
          ),
        ],
      ),
    );
  }
}
