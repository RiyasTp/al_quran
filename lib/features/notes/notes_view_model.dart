import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:flutter/foundation.dart';

class NotesViewModel extends ChangeNotifier {
  final _dbHelper = NotesDatabaseHelper.instance;

  Future<List<Note>> getAllNotes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('notes', orderBy: 'updated_at DESC');
    if (maps.isEmpty) {
      return [];
    }
    final notes = <Note>[];
    for (final map in maps) {
      final note = Note.fromMap(map);
      final tags = await _dbHelper.getTagsForNote(note.id);
      notes.add(note.copyWith(tags: tags));
    }

    return notes;
  }

  Future<bool> hasNotesForAyah(int surahNumber, int ayahNumber) async {
    final note = await _dbHelper.hasNoteForAyah(surahNumber, ayahNumber);
    return note;
  }

  Future<List<Note>?> getNotes(int surahNumber, int ayahNumber) async {
    return await _dbHelper.getNotesForAyah(surahNumber, ayahNumber);
  }

  Future<Note?> getNoteForAyah(int surahNumber, int ayahNumber) async {
    try {
      return await _dbHelper.getNoteForAyah(surahNumber, ayahNumber);
    } finally {
      notifyListeners();
    }
  }

  Future<int> addNote(Note note) async {
    try {
      return await _dbHelper.addNote(note);
    } finally {
      notifyListeners();
    }
  }

  Future<int> updateNote(Note note) async {
    try {
      return await _dbHelper.updateNote(note);
    } finally {
      notifyListeners();
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      return await _dbHelper.deleteNote(id);
    } finally {
      notifyListeners();
    }
  }

  Future<List<Tag>> getAllTags() async {
    try {
      return await _dbHelper.getAllTags();
    } finally {
      notifyListeners();
    }
  }

 Future<int> addTag(Tag tag) async {
    try {
      return await _dbHelper.addTag(tag);
    } finally {
      notifyListeners();
    }
  }
  Future<int> deleteTag(int id) async {
    return 1;
    // try {
    //   return await _dbHelper.re(id);
    // } finally {
    //   notifyListeners();
    // }
  }
}
