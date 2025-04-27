import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BookmarkDatabaseHelper {
  static final BookmarkDatabaseHelper instance = BookmarkDatabaseHelper._init();
  static Database? _database;

  BookmarkDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, -- 'surah' or 'ayah'
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Add a bookmark
  Future<int> addBookmark({
    required String type,
    required int surahNumber,
    int? ayahNumber,
  }) async {
    final db = await instance.database;
    
    return await db.insert('bookmarks', {
      'type': type,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Remove a bookmark
  Future<int> removeBookmark({
    required String type,
    required int surahNumber,
    int? ayahNumber,
  }) async {
    final db = await instance.database;
    
    return await db.delete(
      'bookmarks',
      where: 'type = ? AND surah_number = ? AND ayah_number = ?',
      whereArgs: [type, surahNumber, ayahNumber],
    );
  }

  // Check if a bookmark exists
  Future<bool> isBookmarked({
    required String type,
    required int surahNumber,
    int? ayahNumber,
  }) async {
    final db = await instance.database;
    
    final result = await db.query(
      'bookmarks',
      where: 'type = ? AND surah_number = ? AND ayah_number = ?',
      whereArgs: [type, surahNumber, ayahNumber],
    );
    
    return result.isNotEmpty;
  }

  // Get all bookmarks
  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    final db = await instance.database;
    return await db.query('bookmarks', orderBy: 'created_at DESC');
  }
}