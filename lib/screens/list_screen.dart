import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/study_spot.dart';
import 'detail_screen.dart';
import 'add_spot_screen.dart';

/// List screen - displays all study spots with search and filter.
/// TODO: Implement full UI with ListView, ListTile, search, FilterChips.
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<StudySpot> _spots = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    final spots = await DatabaseHelper.instance.getAllSpots();
    setState(() {
      _spots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Spots'),
      ),
      body: const Center(
        child: Text('TODO: Implement List Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add New Spot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSpotScreen()),
          ).then((_) => _loadSpots()); // Refresh list on return
        },
        backgroundColor: const Color(0xFF185FA5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
