import 'package:al_quran/design_system/components/custom_card.dart';
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/screens/sura_aya_wise_screen.dart';
import 'package:al_quran/features/al_quran/view_models/quran_view_model.dart';
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:al_quran/features/notes/notes_view_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_view_model.dart';
import 'package:al_quran/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({
    super.key,
    this.suraNumber,
    this.ayahNumber,
    this.margin,
  });

  final int? suraNumber;
  final int? ayahNumber;
  final EdgeInsets? margin;

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  @override
  Widget build(BuildContext context) {
    final quranVM = context.read<QuranViewModel>();
    var quranData = quranVM.quranData;
    final quranMetaData = quranVM.quranMetaData;
    final quranTranslationData = quranVM.quranTranslationData;
    final notesVM = context.read<NotesViewModel>();
    return FutureBuilder<List<Note>?>(
      future: notesVM.getNotes(),
      builder: (context, snapshot) {
        context.watch<NotesViewModel>();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        var isAyawise =
            (widget.suraNumber == null || widget.ayahNumber == null);

        final notes = !isAyawise
            ? notesVM.getAyawiseNotes(widget.suraNumber, widget.ayahNumber)
            : notesVM.notes;
        if (notes.isEmpty) {
          return Center(
              child: isAyawise
                  ? Text("No notes found")
                  : Text('No notes found for this verse.'));
        }

        return ListView.builder(
          shrinkWrap: true,
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
              margin: widget.margin,
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                title: Row(children: [
                  Expanded(
                      child: Text(
                          'Surah ${suraMetaData.tname} ${note.surahNumber}:${note.ayahNumber}')),
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
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
                ]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    divider,
                    SizedBox(height: 4),
                    
                    Text(
                      note.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (note.tags.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: note.tags
                            .map((tag) => Chip(
                                  label: Text(tag.name),
                                  backgroundColor: tag.color.withOpacity(0.2),
                                ))
                            .toList(),
                      ),
                    ],
                    Text(
                      note.updatedAt.isAfter(
                              note.createdAt.add(const Duration(seconds: 1)))
                          ? 'Updated: ${note.updatedAt.toLocal().toString().split(' ')[0]}'
                          : 'Created: ${note.createdAt.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () {
                  showNotesBottomSheet(
                    context,
                    showReference: isAyawise,
                    note: note,
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
    );
  }

  Future<void> onDelete(Note note) async {
    // Show confirmation dialog before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final notesVM = context.read<NotesViewModel>();
    await notesVM.deleteNote(note.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note deleted successfully')),
    );
    setState(() {});
  }

  Future<void> onEdit(BuildContext context, Note note) async {
    await showNotesEditorSheet(
      context,
      surahNumber: note.surahNumber,
      ayahNumber: note.ayahNumber,
      existingNote: note,
    );
  }

  void openSura(
      Note bookmark,
      List<Sura> quranData,
      List<SuraMetaData> quranMetaData,
      List<SuraTranslation> quranTranslationData,
      BuildContext context) async {
    var i = bookmark.surahNumber - 1;
    final sura = quranData[i];
    final suraMetaData = quranMetaData[i];
    final suraTranslation = quranTranslationData[i];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AyahPage(
            sura: sura,
            suraMetaData: suraMetaData,
            suraTranslation: suraTranslation,
            initialAyahIndex: bookmark.ayahNumber),
      ),
    );
    setState(() {});
  }
}
