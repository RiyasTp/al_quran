import 'package:al_quran/design_system/components/custom_card.dart';
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:al_quran/features/notes/notes_view_bottom_sheet.dart';
import 'package:al_quran/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final quranVM = context.read<QuranViewModel>();
    var quranData = quranVM.quranData;
    final quranMetaData = quranVM.quranMetaData;
    final quranTranslationData = quranVM.quranTranslationData;
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
                var i = note.surahNumber - 1;
                var ayaIndex = note.ayahNumber - 1;
                final sura = quranData[i];
                final suraMetaData = quranMetaData[i];
                final suraTranslation = quranTranslationData[i];
                final aya = sura.ayas[ayaIndex];
                final ayaTranslation = suraTranslation.ayas[ayaIndex];
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
                            await onEdit(context, note);
                          } else if (value == 'delete') {
                            await onDelete(note);
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
                          note.updatedAt.isAfter(note.createdAt
                                  .add(const Duration(seconds: 1)))
                              ? 'Updated: ${note.updatedAt.toLocal().toString().split(' ')[0]}'
                              : 'Created: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      showNotesBottomSheet(
                        context,
                        onEdit: () => onEdit(context, note),
                        onOpen: () async => openSura(
                          note,
                          quranData,
                          quranMetaData,
                          quranTranslationData,
                          context,
                        ),
                        noteText: note.content,
                        arabicText: aya.text +
                            nonBreakSpaceChar +
                            toArabicNumerals(aya.index),
                        translationText: ayaTranslation.text,
                        translationReference:
                            "Surah ${suraMetaData.tname} (${suraMetaData.ename})  ${sura.index} : ${aya.index}",
                        arabicReference:
                            "سورة$nonBreakSpaceChar${sura.name}$nonBreakSpaceChar•$nonBreakSpaceChar${toArabicNumerals(sura.index)}$nonBreakSpaceChar:$nonBreakSpaceChar${toArabicNumerals(aya.index)}",
                      );
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

  Future<void> onDelete(Note note) async {
    await _dbHelper.deleteNote(note.id);
    _refreshNotes();
  }

  Future<void> onEdit(BuildContext context, Note note) async {
    await showNotesEditorSheet(
      context,
      surahNumber: note.surahNumber,
      ayahNumber: note.ayahNumber,
      existingNote: note,
    );
    _refreshNotes();
  }

  void openSura(
      Note bookmark,
      List<Sura> quranData,
      List<SuraMetaData> quranMetaData,
      List<SuraTranslation> quranTranslationData,
      BuildContext context) {
    var i = bookmark.surahNumber - 1;
    final sura = quranData[i];
    final suraMetaData = quranMetaData[i];
    final suraTranslation = quranTranslationData[i];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AyahPage(
            sura: sura,
            suraMetaData: suraMetaData,
            suraTranslation: suraTranslation,
            initialAyahIndex: bookmark.ayahNumber),
      ),
    );
  }
}
