import 'package:al_quran/features/al_quran/widgets/constant_widgets.dart';
import 'package:flutter/material.dart';

void showNotesAyaViewBottomSheet(
  BuildContext context, {
  required String arabicText,
  required String translationText,
  required String translationReference,
  required String arabicReference,
  required Future<void> Function() onOpen,
}) {
  bool copyArabic = true;
  bool copyTranslation = true;

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
          return Container(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  translationReference,
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
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text.rich(
                              TextSpan(children: [
                                if (copyArabic)
                                  TextSpan(
                                    text: arabicText,
                                    style: TextStyle(
                                      fontFamily: "Hafs2",
                                      fontSize: 26,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                if (copyArabic)
                                  TextSpan(
                                    text: "  $arabicReference",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (copyArabic && copyTranslation)
                                  const TextSpan(
                                    text: "\n",
                                  ),
                                if (copyTranslation)
                                  TextSpan(
                                    text: "\n$translationText",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                TextSpan(
                                  text: "\n $translationReference",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
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
                    const Text("Show Aya (Arabic)"),
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
                    const Text("show Translation"),
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
                        child: const Text("Close"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onOpen,
                        icon: Icon(Icons.chevron_right),
                        label: const Text("Goto Aya"),
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
