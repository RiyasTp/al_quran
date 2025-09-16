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
    saveSettings(settings);
    notifyListeners();
  }

  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quranFontSize', settings.quranFontSize);
    await prefs.setDouble('translationFontSize', settings.translationFontSize);
    await prefs.setDouble('appFontSize', settings.appFontSize);
    await prefs.setString('quranFontFamily', settings.quranFontFamily);
    await prefs.setString('themeMode', settings.themeMode.toString());
    await prefs.setString('translationAuthor', settings.translationAuthor);
    await prefs.setString('quranReciter', settings.reciterId);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return _settings = AppSettings(
      quranFontSize: prefs.getDouble('quranFontSize'),
      translationFontSize: prefs.getDouble('translationFontSize'),
      appFontSize: prefs.getDouble('appFontSize'),
      quranFontFamily: prefs.getString('quranFontFamily') ,
      themeMode: _stringToThemeMode(prefs.getString('themeMode')),
      showTaranslation: prefs.getBool('showTaranslation'),
      translationAuthor: prefs.getString('translationAuthor'),
      reciterId: prefs.getString('quranReciter'),
    );
  }

  ThemeMode _stringToThemeMode(String? themeModeString) {
    switch (themeModeString) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }
}
