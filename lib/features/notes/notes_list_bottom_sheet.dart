import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/features/notes/edit_notes_bottom_sheet.dart';
import 'package:al_quran/features/notes/notes_list_widget.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:al_quran/features/notes/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showNotesListBottomSheet(
  BuildContext context, {
  required int suraNumber,
  required int ayahNumber,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FutureBuilder<List<Note>?>(
          future:
              context.read<NotesViewModel>().getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final notes = snapshot.data ?? [];
            if (notes.isEmpty) {
              return Center(child: Text('No notes found for this verse.'));
            }
            final screenHeight = MediaQuery.of(context).size.height;
            final appBarHeight = kToolbarHeight;
            final maxSheetHeight = screenHeight - appBarHeight - 24;
            return Container(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      "Notes for $suraNumber : $ayahNumber",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),

                    divider,
                    const SizedBox(height: 8),
                    Flexible(child: NotesListView(suraNumber: suraNumber, ayahNumber: ayahNumber, margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              showNotesEditorSheet(
                                context,
                                surahNumber: suraNumber,
                                ayahNumber: ayahNumber,
                                existingNote: null,
                              );
                            },
                            icon: Icon(Icons.add),
                            label: const Text("Add new note"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          });
    },
  );
}
//                   child: SingleChildScrollView(
