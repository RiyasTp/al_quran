import 'dart:developer';

import 'package:al_quran/features/al_quran/models/quran_models.dart';
import 'package:xml/xml.dart' as xml;

List<SuraTranslation> parseQuranTranslation(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final suras = <SuraTranslation>[];

  final quranData = document.findElements('quran').first;

  for (final suraElement in quranData.findElements('sura')) {
    log(suraElement.getAttribute('name').toString());
    final ayas = <AyaTranslation>[];

    for (final ayaElement in suraElement.findElements('aya')) {
      final aya = AyaTranslation(
        index: int.parse(ayaElement.getAttribute('index')!),
        text: ayaElement.getAttribute('text')!,
      );
      ayas.add(aya);
    }

    final sura = SuraTranslation(
      index: int.parse(suraElement.getAttribute('index')!),
      ayas: ayas,
    );
    suras.add(sura);
  }

  return suras;
}

List<Sura> parseQuran(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final suras = <Sura>[];

  final quranData = document.findElements('quran').first;

  for (final suraElement in quranData.findElements('sura')) {
    log(suraElement.getAttribute('name').toString());
    final ayas = <Aya>[];

    for (final ayaElement in suraElement.findElements('aya')) {
      final aya = Aya(
        index: int.parse(ayaElement.getAttribute('index')!),
        text: ayaElement.getAttribute('text')!,
        bismillah: ayaElement.getAttribute('bismillah'),
      );
      ayas.add(aya);
    }

    final sura = Sura(
      index: int.parse(suraElement.getAttribute('index')!),
      name: suraElement.getAttribute('name')!,
      ayas: ayas,
    );
    suras.add(sura);
  }

  return suras;
}

List<SuraMetaData> parseQuranMetaData(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final suras = <SuraMetaData>[];
  final quranData = document.findElements('quran').first;
  final suraMetaData = quranData.findElements('suras').first;

  for (final suraElement in suraMetaData.findAllElements('sura')) {
    final sura = SuraMetaData(
      index: int.parse(suraElement.getAttribute('index')!),
      name: suraElement.getAttribute('name')!,
      tname: suraElement.getAttribute('tname')!,
      ename: suraElement.getAttribute('ename')!,
      type: suraElement.getAttribute('type')!,
      order: int.parse(suraElement.getAttribute('order')!),
      rukus: int.parse(suraElement.getAttribute('rukus')!),
      ayas: int.parse(suraElement.getAttribute('ayas')!),
      start: int.parse(suraElement.getAttribute('start')!),
    );
    suras.add(sura);
  }

  return suras;
}

List<QuranPage> parseQuranPages(String xmlString, List<Sura> quranData) {
  final document = xml.XmlDocument.parse(xmlString);
  final quranElement = document.findElements('quran').first;
  final pagesElement = quranElement.findElements('pages');
  final pageElements = pagesElement.first.findElements('page').toList();
  final pages = <QuranPage>[];

  for (int i = 0; i < pageElements.length; i++) {
    final page = QuranPage.fromXml({
      'index': pageElements[i].getAttribute('index')!,
      'sura': pageElements[i].getAttribute('sura')!,
      'aya': pageElements[i].getAttribute('aya')!,
    });

    // Special handling for last page
    if (i == pageElements.length - 1) {
      page.endSura = 114; // Last surah
      final lastSura = quranData.firstWhere((s) => s.index == 114);
      page.endAya = lastSura.ayas.last.index;
    } else {
      final nextPage = QuranPage.fromXml({
        'index': pageElements[i + 1].getAttribute('index')!,
        'sura': pageElements[i + 1].getAttribute('sura')!,
        'aya': pageElements[i + 1].getAttribute('aya')!,
      });

      if (nextPage.startSura == page.startSura) {
        // Same sura continues
        page.endSura = page.startSura;
        page.endAya = nextPage.startAya - 1;
      } else if ((nextPage.startAya) == 1) {
        final prevSura = nextPage.startSura - 1;
        final prevSuraData = quranData.firstWhere((s) => s.index == prevSura);
        final prevSuraAya = prevSuraData.ayas.last.index;

        page.endSura = prevSura;
        page.endAya = prevSuraAya;
      } else {
        // Next sura starts - include all remaining ayahs of current sura
        page.endSura = page.startSura;
        final currentSura =
            quranData.firstWhere((s) => s.index == page.startSura);
        page.endAya = currentSura.ayas.last.index;
      }
    }

    pages.add(page);
  }

  return pages;
}

List<QuranJuz> parseQuranJuz(String xmlString, List<Sura> quranData) {
  final document = xml.XmlDocument.parse(xmlString);
  final quranElement = document.findElements('quran').first;
  final juzsElement = quranElement.findElements('juzs');
  final juzElements = juzsElement.first.findElements('juz').toList();
  final juzs = <QuranJuz>[];

  for (int i = 0; i < juzElements.length; i++) {
    final juz = QuranJuz.fromXml({
      'index': juzElements[i].getAttribute('index')!,
      'sura': juzElements[i].getAttribute('sura')!,
      'aya': juzElements[i].getAttribute('aya')!,
    });

    // Special handling for last page
    if (i == juzElements.length - 1) {
      juz.endSura = 114; // Last surah
      final lastSura = quranData.firstWhere((s) => s.index == 114);
      juz.endAya = lastSura.ayas.last.index;
    } else {
      final nextJuz = QuranJuz.fromXml({
        'index': juzElements[i + 1].getAttribute('index')!,
        'sura': juzElements[i + 1].getAttribute('sura')!,
        'aya': juzElements[i + 1].getAttribute('aya')!,
      });

      if (nextJuz.startSura == juz.startSura) {
        // Same sura continues
        juz.endSura = juz.startSura;
        juz.endAya = nextJuz.startAya - 1;
      } else if ((nextJuz.startAya) == 1) {
        final prevSura = nextJuz.startSura - 1;
        final prevSuraData = quranData.firstWhere((s) => s.index == prevSura);
        final prevSuraAya = prevSuraData.ayas.last.index;

        juz.endSura = prevSura;
        juz.endAya = prevSuraAya;
      } else {
        // Next sura starts - include all remaining ayahs of current sura
        juz.endSura = nextJuz.startSura;
        juz.endAya = nextJuz.startAya - 1;
      }
    }

    juzs.add(juz);
  }

  return juzs;
}

List<QuranHizb> parseQuranHizbs(String xmlString, List<Sura> quranData) {
  final document = xml.XmlDocument.parse(xmlString);
  final quranElement = document.findElements('quran').first;
  final hizbsElement = quranElement.findElements('juzs');
  final hizbElements = hizbsElement.first.findElements('juz').toList();
  final hizbs = <QuranHizb>[];

  for (int i = 0; i < hizbElements.length; i++) {
    final juz = QuranHizb.fromXml({
      'index': hizbElements[i].getAttribute('index')!,
      'sura': hizbElements[i].getAttribute('sura')!,
      'aya': hizbElements[i].getAttribute('aya')!,
    });

    // Special handling for last page
    if (i == hizbElements.length - 1) {
      juz.endSura = 114; // Last surah
      final lastSura = quranData.firstWhere((s) => s.index == 114);
      juz.endAya = lastSura.ayas.last.index;
    } else {
      final nextPage = QuranHizb.fromXml({
        'index': hizbElements[i + 1].getAttribute('index')!,
        'sura': hizbElements[i + 1].getAttribute('sura')!,
        'aya': hizbElements[i + 1].getAttribute('aya')!,
      });

      if (nextPage.startSura == juz.startSura) {
        // Same sura continues
        juz.endSura = juz.startSura;
        juz.endAya = nextPage.startAya - 1;
      } else if ((nextPage.startAya) == 1) {
        final prevSura = nextPage.startSura - 1;
        final prevSuraData = quranData.firstWhere((s) => s.index == prevSura);
        final prevSuraAya = prevSuraData.ayas.last.index;

        juz.endSura = prevSura;
        juz.endAya = prevSuraAya;
      } else {
        // Next sura starts - include all remaining ayahs of current sura
        juz.endSura = juz.startSura;
        final currentSura =
            quranData.firstWhere((s) => s.index == juz.startSura);
        juz.endAya = currentSura.ayas.last.index;
      }
    }

    hizbs.add(juz);
  }

  return hizbs;
}

List<T> parseQuranTypeWise<T extends QuranTypeWiseData>(
    String xmlString, List<Sura> quranData) {
  final document = xml.XmlDocument.parse(xmlString);
  final quranElement = document.findElements('quran').first;

  // Get the appropriate XML element names based on the type T
  final type = _getElementNames<T>();
    
  final parentElements = quranElement.findElements(type.parentElement);
  final childElements =
      parentElements.first.findElements(type.childElement).toList();
  final items = <T>[];

  for (int i = 0; i < childElements.length; i++) {
    final item = _createQuranTypeWiseData<T>({
      'index': childElements[i].getAttribute('index')!,
      'sura': childElements[i].getAttribute('sura')!,
      'aya': childElements[i].getAttribute('aya')!,
    });

    // Special handling for last item
    if (i == childElements.length - 1) {
      item.endSura = 114; // Last surah
      final lastSura = quranData.firstWhere((s) => s.index == 114);
      item.endAya = lastSura.ayas.last.index;
    } else {
      final nextItem = _createQuranTypeWiseData<T>({
        'index': childElements[i + 1].getAttribute('index')!,
        'sura': childElements[i + 1].getAttribute('sura')!,
        'aya': childElements[i + 1].getAttribute('aya')!,
      });

      if (nextItem.startSura == item.startSura) {
        // Same sura continues
        item.endSura = item.startSura;
        item.endAya = nextItem.startAya - 1;
      } else if ((nextItem.startAya) == 1) {
        final prevSura = nextItem.startSura - 1;
        final prevSuraData = quranData.firstWhere((s) => s.index == prevSura);
        final prevSuraAya = prevSuraData.ayas.last.index;

        item.endSura = prevSura;
        item.endAya = prevSuraAya;
      } else {
        // Next sura starts - include all remaining ayahs of current sura
        item.endSura = nextItem.startSura;
        item.endAya = nextItem.startAya - 1;
      }
    }

    items.add(item as T);
  }

  return items;
}

QuranDataType _getElementNames<T extends QuranTypeWiseData>() {
  if (T == QuranPage) {
    return QuranDataType.page;
  } else if (T == QuranJuz) {
    return QuranDataType.juz;
  } else if (T == QuranHizb) {
    return QuranDataType.hizb;
  }
  throw ArgumentError('Unsupported type: $T');
}

T _createQuranTypeWiseData<T extends QuranTypeWiseData>(
    Map<String, dynamic> xml) {
  if (T == QuranPage) {
    return QuranPage.fromXml(xml) as T;
  } else if (T == QuranJuz) {
    return QuranJuz.fromXml(xml) as T;
  } else if (T == QuranHizb) {
    return QuranHizb.fromXml(xml) as T;
  }
  throw ArgumentError('Unsupported type: $T');
}
