// StudySpot model representing a study location.
// Maps directly to the study_spot table in SQLite.
class StudySpot {
  final int? id;
  final String name;
  final String category;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final String amenities; // comma-separated: wifi,power,quiet,food
  final String notes;
  final String imagePath;
  final bool isFavorite;
  final String createdAt;

  StudySpot({
    this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating = 0.0,
    this.amenities = '',
    this.notes = '',
    this.imagePath = '',
    this.isFavorite = false,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  /// Convert StudySpot to Map for SQLite insert/update
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'amenities': amenities,
      'notes': notes,
      'image_path': imagePath,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt,
    };
  }

  /// Create StudySpot from SQLite Map.
  factory StudySpot.fromMap(Map<String, dynamic> map) {
    return StudySpot(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      address: map['address'] as String? ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      amenities: map['amenities'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      imagePath: map['image_path'] as String? ?? '',
      isFavorite: (map['is_favorite'] as int?) == 1,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  /// Create a copy with modified fields.
  StudySpot copyWith({
    int? id,
    String? name,
    String? category,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    String? amenities,
    String? notes,
    String? imagePath,
    bool? isFavorite,
    String? createdAt,
  }) {
    return StudySpot(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get amenities as a list.
  List<String> get amenitiesList =>
      amenities.isEmpty ? [] : amenities.split(',').map((e) => e.trim()).toList();

  @override
  String toString() => 'StudySpot(id: $id, name: $name, category: $category)';
}