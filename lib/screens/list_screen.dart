import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/study_spot.dart';
import 'detail_screen.dart';
import 'add_spot_screen.dart';

/// List Screen - Tab 1: Browse all study spots.
/// Features: search bar, category filter chips, ListView with ListTile,
/// FAB to add new spot.
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<StudySpot> _allSpots = [];
  List<StudySpot> _filteredSpots = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Library',
    'Cafe',
    'Co-working',
    'Outdoor',
  ];

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  /// Load all spots from SQLite database.
  Future<void> _loadSpots() async {
    setState(() => _isLoading = true);
    final spots = await DatabaseHelper.instance.getAllSpots();
    setState(() {
      _allSpots = spots;
      _applyFilters();
      _isLoading = false;
    });
  }

  /// Apply search query and category filter to the spot list.
  void _applyFilters() {
    List<StudySpot> result = _allSpots;

    // Filter by category
    if (_selectedCategory != 'All') {
      result = result
          .where((spot) =>
      spot.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((spot) =>
      spot.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot.amenities.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredSpots = result;
  }

  /// Get icon for each category.
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return Icons.local_library;
      case 'cafe':
        return Icons.coffee;
      case 'co-working':
        return Icons.business;
      case 'outdoor':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  /// Get color for each category.
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return const Color(0xFF185FA5);
      case 'cafe':
        return const Color(0xFF1D9E75);
      case 'co-working':
        return const Color(0xFFBA7517);
      case 'outdoor':
        return const Color(0xFF534AB7);
      default:
        return Colors.grey;
    }
  }

  /// Build star rating widget.
  Widget _buildRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, size: 14, color: Color(0xFFEF9F27));
          } else if (index < rating) {
            return const Icon(Icons.star_half, size: 14, color: Color(0xFFEF9F27));
          } else {
            return const Icon(Icons.star_border, size: 14, color: Color(0xFFEF9F27));
          }
        }),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Study Spots',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${_filteredSpots.length} spots found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ),

            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _applyFilters();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _applyFilters();
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // ===== FILTER CHIPS =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 0, 8),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                          isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _applyFilters();
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF185FA5),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF185FA5)
                            : Colors.grey[300]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  },
                ),
              ),
            ),

            // ===== LIST =====
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredSpots.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: _loadSpots,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                  itemCount: _filteredSpots.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final spot = _filteredSpots[index];
                    return _buildSpotCard(spot);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== FAB =====
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add New Spot screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSpotScreen(),
            ),
          );
          // Refresh list when returning
          if (result == true) {
            _loadSpots();
          }
        },
        backgroundColor: const Color(0xFF185FA5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build a single study spot card.
  Widget _buildSpotCard(StudySpot spot) {
    final categoryColor = _getCategoryColor(spot.category);
    final categoryIcon = _getCategoryIcon(spot.category);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          // Navigate to Detail screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(spot: spot),
            ),
          );
          // Refresh list when returning
          if (result == true) {
            _loadSpots();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),

              // Spot info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + favorite icon
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            spot.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (spot.isFavorite)
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFEF9F27),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Category + amenities
                    Text(
                      [
                        spot.category,
                        ...spot.amenitiesList.take(2),
                      ].join(' · '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    _buildRating(spot.rating),
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right,
                color: Colors.grey[300],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build empty state when no spots found.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'No spots match your search'
                : 'No study spots yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'Try different keywords or filters'
                : 'Tap + to add your first study spot!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}