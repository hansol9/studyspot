import 'package:flutter/material.dart';

/// Favorites screen - displays bookmarked study spots.
/// TODO: Implement with ListView, Dismissible for swipe-to-remove.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: const Center(
        child: Text('TODO: Implement Favorites Screen'),
      ),
    );
  }
}
