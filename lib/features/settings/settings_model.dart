// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const _MAX_FONT_SIZE = 2.0;
const MIN_FONT_SIZE = 0.5;
const _DEFAULT_FONT_SIZE = 1.0;

const DEFAULT_FONT_FAMILY = 'Hafs';
const ALL_FONT_FAMILIES = [
  'Hafs',
];

const DEFAULT_TRANSLATION_AUTHOR = 'Sahih International';
const ALL_TRANSLATION_AUTHORS = [
  'Sahih International',
];

const DEFAULT_RECITATION =  'Abdul Basit Murattal';
const ALL_RECITATIONS = [
  'Abdul Basit Murattal',
];


class AppSettings {
  ThemeMode _themeMode = ThemeMode.system;
  double _quranFontSize = _DEFAULT_FONT_SIZE;
  double _tafseerFontSize = _DEFAULT_FONT_SIZE;
  double _appFontSize = _DEFAULT_FONT_SIZE;
  String _fontFamily = 'Hafs';
  bool _showTaranslation = true;
  String _translationAuthor = 'Ibn Kathir';

  AppSettings({
    double quranFontSize = 1,
    double tafseerFontSize = 1,
    double appFontSize = 1,
    String fontFamily = 'Hafs',
    bool showTaranslation = true,
    String translationAuthor = 'Ibn Kathir',
    ThemeMode themeMode = ThemeMode.system,
  })  : _quranFontSize = quranFontSize,
        _tafseerFontSize = tafseerFontSize,
        _appFontSize = appFontSize,
        _fontFamily = fontFamily,
        _showTaranslation = showTaranslation,
        _translationAuthor = translationAuthor,
        _themeMode = themeMode;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) => _themeMode = value;

  double get quranFontSize => _quranFontSize;
  set quranFontSize(double value) {
    if (value < MIN_FONT_SIZE) {
      value = MIN_FONT_SIZE;
    } else if (value > _MAX_FONT_SIZE) {
      value = _MAX_FONT_SIZE;
    }
    _quranFontSize = value;
  }

  double get tafseerFontSize => _tafseerFontSize;
  set tafseerFontSize(double value) {
    if (value < MIN_FONT_SIZE) {
      value = MIN_FONT_SIZE;
    } else if (value > _MAX_FONT_SIZE) {
      value = _MAX_FONT_SIZE;
    }
    _tafseerFontSize = value;
  }

  double get appFontSize => _appFontSize;
  set appFontSize(double value) {
    if (value < MIN_FONT_SIZE) {
      value = MIN_FONT_SIZE;
    } else if (value > _MAX_FONT_SIZE) {
      value = _MAX_FONT_SIZE;
    }
    _appFontSize = value;
  }

  String get fontFamily => _fontFamily;
  set fontFamily(String value) => _fontFamily = value;

  bool get showTaranslation => _showTaranslation;
  set showTaranslation(bool value) => _showTaranslation = value;

  String get translationAuthor => _translationAuthor;
  set translationAuthor(String value) => _translationAuthor = value;

  AppSettings copyWith({
    double? quranFontSize,
    double? tafseerFontSize,
    double? appFontSize,
    String? fontFamily,
    bool? showTaranslation,
    String? translationAuthor,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      quranFontSize: quranFontSize ?? _quranFontSize,
      tafseerFontSize: tafseerFontSize ?? _tafseerFontSize,
      appFontSize: appFontSize ?? _appFontSize,
      fontFamily: fontFamily ?? _fontFamily,
      showTaranslation: showTaranslation ?? _showTaranslation,
      translationAuthor: translationAuthor ?? _translationAuthor,
      themeMode: themeMode ?? _themeMode,
    );
  }
}
