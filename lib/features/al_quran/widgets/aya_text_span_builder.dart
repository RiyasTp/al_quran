import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/main.dart';
import 'package:flutter/material.dart';

List<TextSpan> ayaTextSpanBuilder(
  BuildContext context,
  Aya aya,
) {
  // Define a non-breaking space character
  const String nonBreakSpaceChar = '\u200B';

  List<TextSpan> spans = [];
  final specialSymbols = {'ۗ', 'ۙ', 'ۚ', 'ۛ', 'ۖ'};

  var text = '';

  for (int i = 0; i < aya.text.length; i++) {
    final char = aya.text[i];
    if (!specialSymbols.contains(char)) {
      text += char;
    } else {
      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: "Hafs",
            fontSize: 26,
          ),
        ),
      );
      text = '';
      spans.add(
        TextSpan(
          text: char,
          style: TextStyle(
            color: Colors.red,
            fontFamily: "Hafs",
            fontSize: 26,
          ),
        ),
      );
    }
  }
  spans.add(
    TextSpan(
      text: text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontFamily: "Hafs",
        fontSize: 26,
      ),
    ),
  );
  // Add the index at the end
  spans.add(
    TextSpan(
      text: "$nonBreakSpaceChar${toArabicNumerals(aya.index)}",
      style: TextStyle(
        fontFamily: "Hafs2",
        fontSize: 26,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  // Wrap all spans in a parent TextSpan with the recognizer
  return spans;
}
