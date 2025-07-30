import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:flutter/material.dart';

Future<void> showBookmarksTitleSheet(
  BuildContext context, {
  required int surahNumber,
  int? ayahNumber,
  required Function(String? title) onSave,
}) async {
  final TextEditingController contentController = TextEditingController();
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final appBarHeight = kToolbarHeight;
        final maxSheetHeight = screenHeight - appBarHeight - 24;

        return Container(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          padding: EdgeInsets.fromLTRB(
              16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Bookmark $surahNumber${ayahNumber != null ? ' : $ayahNumber' : ''}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),

              divider,
              const SizedBox(height: 8),

              TextFormField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Title (Optional)'),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await onSave(contentController.text);
                      },
                      icon: Icon(Icons.save),
                      label: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
