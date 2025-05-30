import 'package:al_quran/features/al_quran/screens/sheets_and_alerts/copy_aya_bottom_sheet.dart';
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:al_quran/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showNotesBottomSheet(BuildContext context,
    {required String arabicText,
    required String translationText,
    required String translationReference,
    required String arabicReference,
    required String noteText,
    required Future<void> Function() onEdit,

    }) {
  bool showArabic = true;
  bool showTranslation = true;
  bool copyReference = true;


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final appBarHeight = kToolbarHeight;
      final maxSheetHeight = screenHeight - appBarHeight - 24;

      return StatefulBuilder(
        builder: (context, setState) {
          String buildCopyText() {
            String result = '';
            if (showArabic)
              result +=
                  "${arabicText.replaceAll(nonBreakSpaceChar, ' ')} ${arabicReference.replaceAll(nonBreakSpaceChar, ' ')}\n";
            if (showTranslation) result += "$translationText\n";
            if (copyReference) result += "📍 $translationReference";
            return result.trim();
          }

          return Container(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Note",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),

                divider,
                const SizedBox(height: 8),
                Flexible(
                    flex: 2,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Scrollbar(
                          radius: Radius.circular(10),
                          thumbVisibility:
                              true, // show scrollbar even when not scrolling
                          trackVisibility: true,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SingleChildScrollView(
                              child: Text(
                                noteText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ))),
                const SizedBox(height: 8),
                // Scrollable text container with max height
                GestureDetector(
                  onTap: () => showCopyBottomSheet(context,
                      arabicText: arabicText,
                      translationText: translationText,
                      translationReference: translationReference,
                      arabicReference: arabicReference),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "📍 $translationReference",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Buttons
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
                        onPressed: () {
                          Navigator.pop(context);
                          onEdit();
                        },
                        icon: Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
