import 'dart:developer';
import 'dart:math' as math;
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/features/notes/db_helper.dart';
import 'package:al_quran/features/notes/notes_model.dart';
import 'package:al_quran/features/notes/notes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteEditorDialog extends StatefulWidget {
  final int surahNumber;
  final int ayahNumber;
  final Note? existingNote;

  const NoteEditorDialog({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.existingNote,
  });

  @override
  createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  List<Tag> _allTags = [];
  List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
    _selectedTags = widget.existingNote?.tags ?? [];
    _loadTags();
  }

  Future<void> _loadTags() async {
    _allTags = await context.read<NotesViewModel>().getAllTags();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.read<NotesViewModel>().getAllTags().then((e)=>log(e.toString())); // Ensure tags are loaded

    return StatefulBuilder(builder: (context, refresh) {
      final screenHeight = MediaQuery.of(context).size.height;
      final appBarHeight = kToolbarHeight;
      final maxSheetHeight = screenHeight - appBarHeight - 24;

      return Container(
        constraints: BoxConstraints(maxHeight: maxSheetHeight),
        padding: EdgeInsets.fromLTRB(
            16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Note for Surah ${widget.surahNumber}:${widget.ayahNumber}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),

                divider,
                const SizedBox(height: 8),

                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Note'),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Tags', style: Theme.of(context).textTheme.bodySmall),
                Wrap(
                  spacing: 8,
                  children: _allTags.map((tag) {
                    final isSelected = _selectedTags.any((t) => t.id == tag.id);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.removeWhere((t) => t.id == tag.id);
                          }
                        });
                      },
                      backgroundColor: tag.color.withOpacity(0.1),
                      selectedColor: tag.color.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : null,
                      ),
                    );
                  }).toList(),
                ),
                TextButton(
                  onPressed: _addNewTag,
                  child: Text('+ Add New Tag'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saveNote,
                        icon: Icon(Icons.save),
                        label: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _addNewTag() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('New Tag'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Tag name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (name != null && name.isNotEmpty) {
      final color = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
      final tag = Tag(
        id: 0, // Will be set by database
        name: name,
        color: color,
      );
      final id = await context.read<NotesViewModel>().addTag(tag);
      tag.id = id;

      setState(() {
        _allTags.add(tag);
        _selectedTags.add(tag);
      });
    }
  }

  Future<void> _saveNote() async {

    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.existingNote?.id ?? 0,
        surahNumber: widget.surahNumber,
        ayahNumber: widget.ayahNumber,
        content: _contentController.text,
        createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        tags: _selectedTags,
      );

      if (widget.existingNote != null) {
        await context.read<NotesViewModel>().updateNote(note);
      } else {
        await context.read<NotesViewModel>().addNote(note);
      }

      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
