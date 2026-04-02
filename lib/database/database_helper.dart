import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/study_spot.dart';

/// Database helper class for SQLite CRUD operations.
/// Implements singleton pattern to ensure single DB instance.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance (lazy initialization).
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('studyspot.db');
    return _database!;
  }

  /// Initialize the database.
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create the study_spots table and insert sample data.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE study_spots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        address TEXT DEFAULT '',
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        rating REAL DEFAULT 0.0,
        amenities TEXT DEFAULT '',
        notes TEXT DEFAULT '',
        image_path TEXT DEFAULT '',
        is_favorite INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Insert sample data so the app is not empty on first launch
    await _insertSampleData(db);
  }

  /// Insert sample study spots for demonstration.
  Future<void> _insertSampleData(Database db) async {
    final sampleSpots = [
      {
        'name': 'Conestoga College Library',
        'category': 'Library',
        'address': '299 Doon Valley Dr, Kitchener, ON',
        'latitude': 43.3894,
        'longitude': -80.4041,
        'rating': 4.2,
        'amenities': 'WiFi,Quiet,Power',
        'notes': 'Great quiet zone on the second floor',
        'image_path': '',
        'is_favorite': 1,
        'created_at': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      },
      {
        'name': 'Settlement Cafe',
        'category': 'Cafe',
        'address': '1430 King St N, St Jacobs, ON',
        'latitude': 43.5153,
        'longitude': -80.5536,
        'rating': 4.7,
        'amenities': 'WiFi,Power,Food',
        'notes': 'Excellent coffee and spacious seating',
        'image_path': '',
        'is_favorite': 1,
        'created_at': DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
      },
      {
        'name': 'Williams Fresh Cafe',
        'category': 'Cafe',
        'address': '170 University Ave W, Waterloo, ON',
        'latitude': 43.4680,
        'longitude': -80.5280,
        'rating': 3.8,
        'amenities': 'WiFi,Food',
        'notes': 'Open late, good for evening study sessions',
        'image_path': '',
        'is_favorite': 0,
        'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      },
      {
        'name': 'Kitchener Public Library',
        'category': 'Library',
        'address': '85 Queen St N, Kitchener, ON',
        'latitude': 43.4530,
        'longitude': -80.4927,
        'rating': 4.5,
        'amenities': 'WiFi,Quiet,Power,Printing',
        'notes': 'Modern building with lots of natural light',
        'image_path': '',
        'is_favorite': 0,
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'name': 'Communitech Hub',
        'category': 'Co-working',
        'address': '151 Charles St W, Kitchener, ON',
        'latitude': 43.4500,
        'longitude': -80.4930,
        'rating': 4.0,
        'amenities': 'WiFi,Power,Quiet',
        'notes': 'Tech hub atmosphere, good for group projects',
        'image_path': '',
        'is_favorite': 0,
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'name': 'Victoria Park',
        'category': 'Outdoor',
        'address': '80 Schneider Ave, Kitchener, ON',
        'latitude': 43.4486,
        'longitude': -80.4870,
        'rating': 3.5,
        'amenities': 'Quiet',
        'notes': 'Nice outdoor spot in good weather, benches available',
        'image_path': '',
        'is_favorite': 0,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (final spot in sampleSpots) {
      await db.insert('study_spots', spot);
    }
  }

  // ==================== CREATE ====================

  /// Insert a new study spot. Returns the id of the inserted row.
  Future<int> insertSpot(StudySpot spot) async {
    final db = await database;
    return await db.insert('study_spots', spot.toMap());
  }

  // ==================== READ ====================

  /// Get all study spots.
  Future<List<StudySpot>> getAllSpots() async {
    final db = await database;
    final maps = await db.query('study_spots', orderBy: 'created_at DESC');
    return maps.map((map) => StudySpot.fromMap(map)).toList();
  }

  /// Get a single study spot by id.
  Future<StudySpot?> getSpotById(int id) async {
    final db = await database;
    final maps = await db.query(
      'study_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return StudySpot.fromMap(maps.first);
  }

  /// Get all favorite spots.
  Future<List<StudySpot>> getFavoriteSpots() async {
    final db = await database;
    final maps = await db.query(
      'study_spots',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => StudySpot.fromMap(map)).toList();
  }

  /// Search spots by name or category.
  Future<List<StudySpot>> searchSpots(String query) async {
    final db = await database;
    final maps = await db.query(
      'study_spots',
      where: 'name LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => StudySpot.fromMap(map)).toList();
  }

  /// Get spots filtered by category.
  Future<List<StudySpot>> getSpotsByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      'study_spots',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => StudySpot.fromMap(map)).toList();
  }

  // ==================== UPDATE ====================

  /// Update an existing study spot. Returns number of rows affected.
  Future<int> updateSpot(StudySpot spot) async {
    final db = await database;
    return await db.update(
      'study_spots',
      spot.toMap(),
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  /// Toggle favorite status for a spot.
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'study_spots',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== DELETE ====================

  /// Delete a study spot by id. Returns number of rows deleted.
  Future<int> deleteSpot(int id) async {
    final db = await database;
    return await db.delete(
      'study_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all study spots (for testing/reset).
  Future<int> deleteAllSpots() async {
    final db = await database;
    return await db.delete('study_spots');
  }

  // ==================== UTILITY ====================

  /// Close the database connection.
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}