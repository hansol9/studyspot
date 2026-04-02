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

  /// Create the study_spots table.
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
