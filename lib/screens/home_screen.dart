import 'package:flutter/material.dart';
import 'list_screen.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';

/// Home screen with BottomNavigationBar.
/// Primary navigation: 3 tabs (Spots, Map, Favorites).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Three tab screens
  final List<Widget> _screens = const [
    ListScreen(),
    MapScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF185FA5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Spots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
