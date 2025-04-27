import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:al_quran/features/al_quran/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuranViewModel extends ChangeNotifier {
  Future<void> initQuranViewModel() async {
    // Initialize any necessary data or state here
    final xmlString =
        await rootBundle.loadString('assets/data/quran-uthmani.xml');
    quranData = parseQuran(xmlString);
    final xmlQuranMetadataString =
        await rootBundle.loadString('assets/data/quran-data.xml');
    quranMetaData = parseQuranMetaData(xmlQuranMetadataString);
    final xmlQuranTranslationString =
        await rootBundle.loadString('assets/data/en.sahih.xml');
    quranTranslationData = parseQuranTranslation(xmlQuranTranslationString);
    
    pages = parseQuranTypeWise(xmlQuranMetadataString, quranData);
    hizbs = parseQuranTypeWise(xmlQuranMetadataString, quranData);
    juzs = parseQuranTypeWise(xmlQuranMetadataString, quranData);
  }

  late List<Sura> quranData;
  late List<SuraMetaData> quranMetaData;
  late List<SuraTranslation> quranTranslationData;
  late List<QuranPage> pages;
  late List<QuranHizb> hizbs;
  late List<QuranJuz> juzs;

 List<QuranTypeWiseData> getDataFromType(QuranDataType type) {
    switch (type) {
      case QuranDataType.page:
        return pages;
      case QuranDataType.hizb:
        return hizbs;
      case QuranDataType.juz:
        return juzs;
      default:
        return pages;
    }
  }
}
