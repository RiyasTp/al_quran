class Aya {
  final int index;
  final String text;
  final String? bismillah;

  Aya({
    required this.index,
    required this.text,
    this.bismillah,
  });
}

class Sura {
  final int index;
  final String name;
  final List<Aya> ayas;

  Sura({
    required this.index,
    required this.name,
    required this.ayas,
  });
}

class AyaTranslation {
  final int index;
  final String text;

  AyaTranslation({
    required this.index,
    required this.text,
  });
}

class SuraTranslation {
  final int index;
  final List<AyaTranslation> ayas;

  SuraTranslation({
    required this.index,
    required this.ayas,
  });
}

class SuraMetaData {
  final int index;
  final String name;
  final String tname;
  final String ename;
  final String type;
  final int order;
  final int rukus;
  final int ayas;
  final int start;

  SuraMetaData({
    required this.index,
    required this.name,
    required this.tname,
    required this.ename,
    required this.type,
    required this.order,
    required this.rukus,
    required this.ayas,
    required this.start,
  });
}

class QuranPage extends QuranTypeWiseData {
  QuranPage({
    required super.index,
    required super.startSura,
    required super.startAya,
    super.endSura,
    super.endAya,
  }) : super(
          type: QuranDataType.page,
        );

  factory QuranPage.fromXml(Map<String, dynamic> xml) {
    return QuranPage(
      index: int.parse(xml['index']),
      startSura: int.parse(xml['sura']),
      startAya: int.parse(xml['aya']),
    );
  }
}

class QuranJuz extends QuranTypeWiseData {
  QuranJuz({
    required super.index,
    required super.startSura,
    required super.startAya,
    super.endSura,
    super.endAya,
  }) : super(
          type: QuranDataType.juz,
        );

  factory QuranJuz.fromXml(Map<String, dynamic> xml) {
    return QuranJuz(
      index: int.parse(xml['index']),
      startSura: int.parse(xml['sura']),
      startAya: int.parse(xml['aya']),
    );
  }
}

class QuranHizb extends QuranTypeWiseData {
  QuranHizb({
    required super.index,
    required super.startSura,
    required super.startAya,
    super.endSura,
    super.endAya,
  }) : super(
          type: QuranDataType.hizb,
        );

  factory QuranHizb.fromXml(Map<String, dynamic> xml) {
    return QuranHizb(
      index: int.parse(xml['index']),
      startSura: int.parse(xml['sura']),
      startAya: int.parse(xml['aya']),
    );
  }
}

abstract class QuranTypeWiseData {
  final int index;
  final int startSura;
  final int startAya;
  final QuranDataType type;
  int? endSura;
  int? endAya;

  static const int pageCount = 604;

  QuranTypeWiseData({
    required this.index,
    required this.startSura,
    required this.startAya,
    required this.type,
    this.endSura,
    this.endAya,
  });
  factory QuranTypeWiseData.fromXml(Map<String, dynamic> xml) {
    throw UnimplementedError(
        'QuranTypeWiseData is an abstract class and cannot be instantiated directly.');
  }
}

enum QuranDataType {
  page('Page', 'pages', 'page'),
  juz('Juz', 'juzs', 'juz'),
  hizb('Hizb', 'hizbs', 'quarter'),
  sura('Sura', 'suras', 'sura'),
  ruku('Rukus', 'rukus', 'ruku'),
  ;

  final String parentElement;
  final String childElement;
  final String typeName;
  const QuranDataType(this.typeName, this.parentElement, this.childElement);
}
