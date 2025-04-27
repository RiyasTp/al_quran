class Bookmark {
  final int id;
  final String type; // 'surah' or 'ayah'
  final int surahNumber;
  final int? ayahNumber;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.type,
    required this.surahNumber,
    this.ayahNumber,
    required this.createdAt,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      type: map['type'],
      surahNumber: map['surah_number'],
      ayahNumber: map['ayah_number'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}