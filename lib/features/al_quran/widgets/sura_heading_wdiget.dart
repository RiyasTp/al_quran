
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical : 16, horizontal: 8),
      child: Text(
        'سورة'
        " "
        "${sura.name}",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
