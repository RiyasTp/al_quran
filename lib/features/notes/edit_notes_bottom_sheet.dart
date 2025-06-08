
import 'dart:developer';

import 'package:al_quran/features/notes/note_editor.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:al_quran/features/notes/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showNotesEditorSheet(
  BuildContext context, {
  required int surahNumber,
  required int ayahNumber,
  required Note? existingNote,
}) async {
 return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return NoteEditorDialog(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          existingNote: existingNote,
        );
      });
}
