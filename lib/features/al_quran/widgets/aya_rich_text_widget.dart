import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/main.dart';
import 'package:flutter/material.dart';

class AyaRichText extends StatelessWidget {
  const AyaRichText({super.key, required this.aya});

  final Aya aya;

  @override
  Widget build(BuildContext context) {
    
 List<TextSpan> spans = [];
  final specialSymbols = {'ۗ', 'ۙ', 'ۚ', 'ۛ', 'ۖ'};

  for (int i = 0; i < aya.text.length; i++) {
    final char = aya.text[i];
    spans.add(
      TextSpan(
        text: char,
        style: TextStyle(
          color: specialSymbols.contains(char) ? Colors.red : null,
          fontFamily: "Hafs",
          fontSize: 26,
        ),
      ),
    );
  }

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
  return  RichText( text:  TextSpan(

      children: spans,
          style: Theme.of(context).textTheme.bodyLarge),
              textDirection: TextDirection.rtl,
        )
    ;
  }
}