
import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:flutter/material.dart';

class SuraHeadingWidget extends StatelessWidget {
  const SuraHeadingWidget({
    super.key,
    required this.sura,
  });

  final Sura sura;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical : 16, horizontal: 8),
        child: Text("${sura.index.toString().padLeft(3, '0')}" "surah", 
        textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontFamily: "Sura Names",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
}
