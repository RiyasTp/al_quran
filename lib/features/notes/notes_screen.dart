import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/notes_list_widget.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _dbHelper = NotesDatabaseHelper.instance;
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = _getNotes();
  }

  Future<List<Note>> _getNotes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('notes', orderBy: 'updated_at DESC');

    final notes = <Note>[];
    for (final map in maps) {
      final note = Note.fromMap(map);
      final tags = await _dbHelper.getTagsForNote(note.id);
      notes.add(note.copyWith(tags: tags));
    }

    return notes;
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = _getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: RefreshIndicator(
        onRefresh: _refreshNotes,
        child: NotesListView(),
      ),
    );
  }
}
