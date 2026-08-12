import 'package:flutter/material.dart';
import 'package:quiz_app/screens/achievement.dart';
import 'package:quiz_app/screens/profile.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/widgets/category_card.dart';
import 'package:quiz_app/utils/color.dart';
import '../data/quiz_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // search controller for the search bar
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  Future<String?>? _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = AuthService.getUsername();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void refreshUsername() {
    setState(() {
      _usernameFuture = AuthService.getUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((category) {
      final query = _searchText.toLowerCase();
      final name = category.name.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.secondaryColor,
        elevation: 0,
        titleSpacing: 16,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: Row(
          children: [
            const SizedBox(width: 12),
            // Greeting + name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  FutureBuilder<String?>(
                    future: _usernameFuture,
                    builder: (context, snapshot) {
                      final username = snapshot.data;
                      return Text(
                        username?.isNotEmpty == true ? username! : 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      );
                    },
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
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: MyColors.secondaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.black54),
              cursorColor: Colors.black54,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.12),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black54.withValues(alpha: 0.6),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black54),
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

class MainScreen extends StatefulWidget {
  final String username;
  const MainScreen({super.key, this.username = 'User'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<_HomeState> _homeKey = GlobalKey<_HomeState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Home(key: _homeKey),
      const AchievementScreen(),
      ProfileScreen(
        onProfileUpdated: () {
          _homeKey.currentState?.refreshUsername();
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Set the color of the selected item
        selectedItemColor: MyColors.secondaryColor,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
