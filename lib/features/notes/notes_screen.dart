import 'package:al_quran/design_system/components/custom_card.dart';
import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
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
                return CustomCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),

                    title: Row(children: [
                      Expanded(
                          child: Text(
                              'Surah ${note.surahNumber}:${note.ayahNumber}')),
                      PopupMenuButton<String>(
                        elevation: 12,
                        shadowColor: Colors.black, //TODO : change to theme
                        splashRadius: 1,
                        color: Theme.of(context).colorScheme.surfaceDim,
                        child: Icon(Icons.more_vert),
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await showNotesEditorSheet(
                              context,
                              surahNumber: note.surahNumber,
                              ayahNumber: note.ayahNumber,
                              existingNote: note,
                            );
                            _refreshNotes();
                          } else if (value == 'delete') {
                            await _dbHelper.deleteNote(note.id);
                            _refreshNotes();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                          ),
                        ],
                      ),
                    ]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (note.tags.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: note.tags
                                .map((tag) => Chip(
                                      label: Text(tag.name),
                                      backgroundColor:
                                          tag.color.withOpacity(0.2),
                                    ))
                                .toList(),
                          ),
                        ],
                        Text(
                          note.updatedAt != null
                              ? 'Updated: ${note.updatedAt!.toLocal().toString().split(' ')[0]}'
                              : 'Created: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {},
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
