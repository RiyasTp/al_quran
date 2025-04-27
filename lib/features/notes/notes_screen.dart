import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/note_editor.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final  _dbHelper = NotesDatabaseHelper.instance;
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
        child: FutureBuilder<List<Note>>(
          future: _notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading notes'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No notes yet'));
            }

            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Surah ${note.surahNumber}:${note.ayahNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content),
                        if (note.tags.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: note.tags.map((tag) => Chip(
                              label: Text(tag.name),
                              backgroundColor: tag.color.withOpacity(0.2),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => NoteEditorDialog(
                            surahNumber: note.surahNumber,
                            ayahNumber: note.ayahNumber,
                            existingNote: note,
                          ),
                        );
                        if (result == true) _refreshNotes();
                      },
                    ),
                    onTap: () {
                     
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}