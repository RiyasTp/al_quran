// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class ReciterModel {
  final String name;
  final String id;

  const ReciterModel({
    required this.name,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReciterModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class RecitersData {
  Future<ReciterModel> getSavedReciter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reciterId = prefs.getString('quranReciter');
      return allRecitations.firstWhere((reciter) => reciter.id == reciterId,
          orElse: () => DEFAULT_RECITATION);
    } catch (e) {
      return DEFAULT_RECITATION;
    }
  }

  Future<void> saveReciter(ReciterModel reciter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quranReciter', reciter.id);
  }

  static const DEFAULT_RECITATION = ReciterModel(name: "Al-Afasy", id: "afasy");

  static const List<ReciterModel> allRecitations = [
    ReciterModel(name: "AbdulBasit", id: "abdulbasit"),
    ReciterModel(name: "AbdulBasit (Mujawwad)", id: "abdulbasit-mjwd"),
    ReciterModel(name: "Basfar", id: "basfar"),
    ReciterModel(name: "Basfar II", id: "basfar2"),
    ReciterModel(name: "Al-Ajamy", id: "ajamy"),
    ReciterModel(name: "Al-Ghamadi", id: "ghamadi"),
    ReciterModel(name: "Al-Hudhaify", id: "hudhaify"),
    ReciterModel(name: "Al-Husary", id: "husary"),
    ReciterModel(name: "Al-Husary (Mujawwad)", id: "husary-mjwd"),
    ReciterModel(name: "Al-Minshawi", id: "minshawi"),
    ReciterModel(name: "Al-Minshawi (Mujawwad)", id: "minshawi-mjwd"),
    ReciterModel(name: "Ash-Shateri", id: "shateri"),
    ReciterModel(name: "Ash-Shuraim", id: "shuraim"),
    ReciterModel(name: "As-Sudais", id: "sudais"),
    ReciterModel(name: "At-Tablawi", id: "tablawi"),
    ReciterModel(name: "Ar-Rafai", id: "hani"),
    ReciterModel(name: "Al-Akhdar", id: "akhdar"),
    ReciterModel(name: "Al-Muaiqly", id: "muaiqly"),
    ReciterModel(name: "Al-Afasy", id: "afasy"),
    ReciterModel(name: "Muhammad Ayyub", id: "ayyub"),
    ReciterModel(name: "Muhammad Jibreel", id: "jibreel"),
    ReciterModel(name: "Parhizgar", id: "parhizgar"),
    ReciterModel(name: "Bukhatir", id: "bukhatir"),
    ReciterModel(name: "Al-Qasim", id: "qasim"),
    ReciterModel(name: "Al-Juhany", id: "juhany"),
    ReciterModel(name: "Al-Matrood", id: "matrood"),
  ];
}
