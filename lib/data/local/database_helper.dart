import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/url_record_model.dart';

/// SQLite database helper for managing scan history.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// Get the database instance, creating it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'phneak_teb.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create the scan_history table.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        status TEXT NOT NULL,
        score INTEGER NOT NULL,
        reasons TEXT NOT NULL,
        source TEXT NOT NULL,
        scannedAt TEXT NOT NULL
      )
    ''');
  }

  /// Insert a new scan record.
  Future<int> insertScanRecord(UrlRecordModel record) async {
    final db = await database;
    return await db.insert(
      'scan_history',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all scan records ordered by most recent first.
  Future<List<UrlRecordModel>> getAllScanRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'scannedAt DESC',
    );
    return maps.map((map) => UrlRecordModel.fromMap(map)).toList();
  }

  /// Get scan records filtered by status.
  Future<List<UrlRecordModel>> getScanRecordsByStatus(String status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'scannedAt DESC',
    );
    return maps.map((map) => UrlRecordModel.fromMap(map)).toList();
  }

  /// Search scan records by URL.
  Future<List<UrlRecordModel>> searchScanRecords(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      where: 'url LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'scannedAt DESC',
    );
    return maps.map((map) => UrlRecordModel.fromMap(map)).toList();
  }

  /// Get a single scan record by ID.
  Future<UrlRecordModel?> getScanRecordById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UrlRecordModel.fromMap(maps.first);
  }

  /// Get the most recent scan records (limited).
  Future<List<UrlRecordModel>> getRecentScans({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'scannedAt DESC',
      limit: limit,
    );
    return maps.map((map) => UrlRecordModel.fromMap(map)).toList();
  }

  /// Delete a single scan record.
  Future<int> deleteScanRecord(int id) async {
    final db = await database;
    return await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all scan records.
  Future<int> deleteAllScanRecords() async {
    final db = await database;
    return await db.delete('scan_history');
  }

  /// Get the total count of scan records.
  Future<int> getScanCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM scan_history');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Close the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
