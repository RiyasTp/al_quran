
import 'package:flutter/material.dart';

class AppSettings {
  var themeMode = ThemeMode.system;
  double quranFontSize;
  double tafseerFontSize;
  double appFontSize;
  String fontFamily;
  bool showTaranslation;
  String translationAuthor;

  AppSettings({
    this.quranFontSize = 22.0,
    this.tafseerFontSize = 16.0,
    this.appFontSize = 14.0,
    this.fontFamily = 'Hafs',
    this.showTaranslation = true,
    this.translationAuthor = 'Ibn Kathir',
  });

  AppSettings copyWith({
    double? quranFontSize,
    double? tafseerFontSize,
    double? appFontSize,
    String? fontFamily,
    bool? showTaranslation,
    String? translationAuthor,
  }) {
    return AppSettings(
      quranFontSize: quranFontSize ?? this.quranFontSize,
      tafseerFontSize: tafseerFontSize ?? this.tafseerFontSize,
      appFontSize: appFontSize ?? this.appFontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      showTaranslation: showTaranslation ?? this.showTaranslation,
      translationAuthor: translationAuthor ?? this.translationAuthor,
    );
  }
}