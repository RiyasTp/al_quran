
import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showCopyBottomSheet(
  BuildContext context, {
  required String arabicText,
  required String translationText,
  required String reference,
}) {
  bool copyArabic = true;
  bool copyTranslation = true;
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
            if (copyArabic) result += "$arabicText\n";
            if (copyTranslation) result += "$translationText\n";
            if (copyReference) result += "📍 $reference";
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
                  "Copy Text",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),

                divider,
                const SizedBox(height: 8),

                // Scrollable text container with max height
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text(
                              buildCopyText(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Small switches
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Copy Aya (Arabic)"),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch.adaptive(
                        value: copyArabic,
                        onChanged: (val) => setState(() => copyArabic = val),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Copy Translation"),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch.adaptive(
                        value: copyTranslation,
                        onChanged: (val) =>
                            setState(() => copyTranslation = val),
                      ),
                    ),
                  ],
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
                          final textToCopy = buildCopyText();
                          Clipboard.setData(ClipboardData(text: textToCopy));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to clipboard")),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: const Text("Copy"),
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
