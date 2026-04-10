import 'package:flutter/material.dart';
import 'list_screen.dart';

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
      appBar: AppBar(title: const Text('Favorites')),
      body: const Center(
        child: Text(''),

        _allSpots.forEach((spot) {
          if (spot.isFavorite == true) {
            Container(
              height: 50,
              color: Colors.amber[100],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(_allSpots.spot.icon),
                  const SizedBox(width: 20),
                  const Text(_allSpots.spot.name),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
