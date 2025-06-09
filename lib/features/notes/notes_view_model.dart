import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:flutter/foundation.dart';

class NotesViewModel extends ChangeNotifier {
  final _dbHelper = NotesDatabaseHelper.instance;

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  List<Note> _ayaNotes = [];
  List<Note> get ayaNotes => _ayaNotes;

  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  Future<List<Note>> _getAllNotes() async {
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

  Future<List<Note>?> getNotes() async {
    var getAllNotes = await _getAllNotes();
    _notes = getAllNotes;
   
      return getAllNotes;
    

  }

 List<Note> getAyawiseNotes(int? surahNumber, int? ayahNumber) {
    final notes = _notes
        .where((note) =>
            note.surahNumber == surahNumber && note.ayahNumber == ayahNumber)
        .toList();
    return notes;
  }

  Future<Note?> getNoteForAyah(int surahNumber, int ayahNumber) async {
    try {
      return await _dbHelper.getNoteForAyah(surahNumber, ayahNumber);
    } finally {
           _onActionComplete();

    }
  }

  Future<int> addNote(Note note) async {
    try {
      return await _dbHelper.addNote(note);
    } finally {
           _onActionComplete();

    }
  }

  Future<int> updateNote(Note note) async {
    try {
      return await _dbHelper.updateNote(note);
    } finally {
           _onActionComplete();

    }
  }

  Future<int> deleteNote(int id) async {
    try {
      return await _dbHelper.deleteNote(id);
    } finally {
      _onActionComplete();
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

  _onActionComplete() async{
    _notes = await _getAllNotes();
    notifyListeners();
  }
}
