import 'package:al_quran/features/notes/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabaseHelper {
  static final NotesDatabaseHelper instance = NotesDatabaseHelper._init();
  static Database? _database;

  NotesDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // New notes table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      surah_number INTEGER NOT NULL,
      ayah_number INTEGER NOT NULL,
      content TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''');

    // Tags table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      color INTEGER NOT NULL
    )
  ''');

    // Junction table for note-tag relationships
    await db.execute('''
    CREATE TABLE IF NOT EXISTS note_tags (
      note_id INTEGER NOT NULL,
      tag_id INTEGER NOT NULL,
      PRIMARY KEY (note_id, tag_id),
      FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
    )
  ''');
  }

  // Note operations
Future<int> addNote(Note note) async {
  final db = await database;
  final id = await db.insert('notes', {
    'surah_number': note.surahNumber,
    'ayah_number': note.ayahNumber,
    'content': note.content,
    'created_at': note.createdAt.toIso8601String(),
    'updated_at': note.updatedAt.toIso8601String(),
  });
  
  // Add tags if any
  if (note.tags.isNotEmpty) {
    for (final tag in note.tags) {
      await _addTagToNote(id, tag.id);
    }
  }
  
  return id;
}

Future<int> updateNote(Note note) async {
  final db = await database;
  return await db.update('notes', {
    'content': note.content,
    'updated_at': DateTime.now().toIso8601String(),
  }, where: 'id = ?', whereArgs: [note.id]);
}

Future<int> deleteNote(int id) async {
  final db = await database;
  return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
}

Future<Note?> getNoteForAyah(int surahNumber, int ayahNumber) async {
  final db = await database;
  final maps = await db.query(
    'notes',
    where: 'surah_number = ? AND ayah_number = ?',
    whereArgs: [surahNumber, ayahNumber],
    limit: 1,
  );
  
  if (maps.isEmpty) return null;
  
  final note = Note.fromMap(maps.first);
  final tags = await getTagsForNote(note.id);
  return note.copyWith(tags: tags);
}

Future<bool> hasNoteForAyah(int surahNumber, int ayahNumber) async {
  final db = await database;
  final count = Sqflite.firstIntValue(await db.rawQuery(
    'SELECT COUNT(*) FROM notes WHERE surah_number = ? AND ayah_number = ?',
    [surahNumber, ayahNumber],
  ));
  return count != null && count > 0;
}

// Tag operations
Future<int> addTag(Tag tag) async {
  final db = await database;
  return await db.insert('tags', tag.toMap());
}

Future<List<Tag>> getAllTags() async {
  final db = await database;
  final maps = await db.query('tags');
  return List.generate(maps.length, (i) => Tag.fromMap(maps[i]));
}

Future<List<Tag>> getTagsForNote(int noteId) async {
  final db = await database;
  final maps = await db.rawQuery('''
    SELECT tags.* FROM tags
    INNER JOIN note_tags ON tags.id = note_tags.tag_id
    WHERE note_tags.note_id = ?
  ''', [noteId]);
  
  return List.generate(maps.length, (i) => Tag.fromMap(maps[i]));
}

Future<void> _addTagToNote(int noteId, int tagId) async {
  final db = await database;
  await db.insert('note_tags', {
    'note_id': noteId,
    'tag_id': tagId,
  }, conflictAlgorithm: ConflictAlgorithm.ignore);
}
}
