
import 'package:al_quran/features/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsViewModel extends ChangeNotifier {
  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void resetSettings() {
    _settings = AppSettings();
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quranFontSize', settings.quranFontSize);
    await prefs.setDouble('tafseerFontSize', settings.tafseerFontSize);
    await prefs.setDouble('appFontSize', settings.appFontSize);
    await prefs.setString('fontFamily', settings.fontFamily);
    await prefs.setBool('showTafseer', settings.showTaranslation);
    await prefs.setString('tafseerAuthor', settings.translationAuthor);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return  _settings =  AppSettings(
      quranFontSize: prefs.getDouble('quranFontSize') ?? 22.0,
      tafseerFontSize: prefs.getDouble('tafseerFontSize') ?? 16.0,
      appFontSize: prefs.getDouble('appFontSize') ?? 14.0,
      fontFamily: prefs.getString('fontFamily') ?? 'UthmanicHafs',
      showTaranslation: prefs.getBool('showTafseer') ?? true,
      translationAuthor: prefs.getString('tafseerAuthor') ?? 'Ibn Kathir',
    );
  }
}
