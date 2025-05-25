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
    await prefs.setString('themeMode', settings.themeMode.toString());

    await prefs.setString('tafseerAuthor', settings.translationAuthor);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return _settings = AppSettings(
      quranFontSize: prefs.getDouble('quranFontSize') ?? 1,
      tafseerFontSize: prefs.getDouble('tafseerFontSize') ?? 1,
      appFontSize: prefs.getDouble('appFontSize') ?? 1,
      fontFamily: prefs.getString('fontFamily') ?? 'UthmanicHafs',
      themeMode: _stringToThemeMode(prefs.getString('themeMode')),
      showTaranslation: prefs.getBool('showTafseer') ?? true,
      translationAuthor: prefs.getString('tafseerAuthor') ?? 'Ibn Kathir',
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
