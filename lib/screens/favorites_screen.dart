import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/study_spot.dart';
import 'detail_screen.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<StudySpot> _allSpots = [];
  List<StudySpot> _favorites = [];
  bool _isLoading = true;

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
      _applyFavorites();
      _isLoading = false;
    });
  }

  /// Filter out spots that have not been marked as favorites by the user
  void _applyFavorites() {
    List<StudySpot> result = _allSpots;
    _favorites = result.where((spot) => spot.isFavorite).toList();
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
                'Favorites',
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
                '${_favorites.length} spots found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ),


            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _favorites.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: _loadSpots,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                  itemCount: _favorites.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final spot = _favorites[index];
                    return _buildSpotCard(spot);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  /// Build a single study spot card.
  Widget _buildSpotCard(StudySpot spot) {
    final categoryColor = _getCategoryColor(spot.category);
    final categoryIcon = _getCategoryIcon(spot.category);

    return Dismissible(
      key: ValueKey(spot.id!),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {

        if (spot.id != null) {
          await DatabaseHelper.instance.deleteSpot(spot.id!);
        }
        _loadSpots();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${spot.name} Removed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                _loadSpots();
              },
            ),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
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
      ),
    );
  }


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
          Text('No Favorites Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text('Save your favorite spots in the details page!',
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