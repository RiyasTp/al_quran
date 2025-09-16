// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:al_quran/features/audio_plyer/reciter_model.dart';
import 'package:flutter/material.dart';

const _MAX_FONT_SIZE = 2.0;
const MIN_FONT_SIZE = 0.5;
const _DEFAULT_FONT_SIZE = 1.0;

const DEFAULT_QURAN_FONT_FAMILY = 'Hafs';
const ALL_FONT_FAMILIES = [
  'Hafs',
];

const DEFAULT_TRANSLATION_AUTHOR = 'Sahih International';
const ALL_TRANSLATION_AUTHORS = [
  'Sahih International',
];

const DEFAULT_RECITATION = RecitersData.DEFAULT_RECITATION;
const ALL_RECITATIONS = RecitersData.allRecitations;

class AppSettings {
  ThemeMode _themeMode = ThemeMode.system;
  double _quranFontSize = _DEFAULT_FONT_SIZE;
  double _translationFontSize = _DEFAULT_FONT_SIZE;
  double _appFontSize = _DEFAULT_FONT_SIZE;
  String _quranFontFamily = DEFAULT_QURAN_FONT_FAMILY;
  bool _showTaranslation = true;
  String _translationAuthor = DEFAULT_TRANSLATION_AUTHOR;
  String _reciterId = RecitersData.DEFAULT_RECITATION.id;

  List<ReciterModel> get allRecitations => ALL_RECITATIONS;
  List<String> get allTranslationAuthors => ALL_TRANSLATION_AUTHORS;
  List<String> get allFontFamilies => ALL_FONT_FAMILIES;

  AppSettings({
    double? quranFontSize = 1,
    double? translationFontSize = 1,
    double? appFontSize = 1,
    String? quranFontFamily = DEFAULT_QURAN_FONT_FAMILY,
    bool? showTaranslation = true,
    String? translationAuthor = DEFAULT_TRANSLATION_AUTHOR,
    String? reciterId,
    ThemeMode? themeMode = ThemeMode.system,
  })  : _quranFontSize = quranFontSize ?? _DEFAULT_FONT_SIZE,
        _translationFontSize = translationFontSize ?? _DEFAULT_FONT_SIZE,
        _appFontSize = appFontSize ?? _DEFAULT_FONT_SIZE,
        _quranFontFamily = quranFontFamily ?? DEFAULT_QURAN_FONT_FAMILY,
        _showTaranslation = showTaranslation ?? true,
        _translationAuthor = translationAuthor ?? DEFAULT_TRANSLATION_AUTHOR,
        _themeMode = themeMode ?? ThemeMode.system,
        _reciterId = reciterId ?? DEFAULT_RECITATION.id;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    log("Setting theme mode to: $value");
    _themeMode = value;
  }

  double get quranFontSize => _quranFontSize;
  set quranFontSize(double value) {
    if (value < MIN_FONT_SIZE) {
      value = MIN_FONT_SIZE;
    } else if (value > _MAX_FONT_SIZE) {
      value = _MAX_FONT_SIZE;
    }
    _quranFontSize = value;
  }

  double get translationFontSize => _translationFontSize;
  set translationFontSize(double value) {
    if (value < MIN_FONT_SIZE) {
      value = MIN_FONT_SIZE;
    } else if (value > _MAX_FONT_SIZE) {
      value = _MAX_FONT_SIZE;
    }
    _translationFontSize = value;
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

  String get quranFontFamily => _quranFontFamily;
  set quranFontFamily(String value) {
    if (!ALL_FONT_FAMILIES.contains(value)) {
      log("Invalid font family: $value. Using default: $DEFAULT_QURAN_FONT_FAMILY");
      value = DEFAULT_QURAN_FONT_FAMILY;
    }
    _quranFontFamily = value;
  }

  bool get showTaranslation => _showTaranslation;
  set showTaranslation(bool value) {
    log("Setting showTaranslation to: $value");
    _showTaranslation = value;
  }

  String get translationAuthor => _translationAuthor;
  set translationAuthor(String value) {
    if (!ALL_TRANSLATION_AUTHORS.contains(value)) {
      log("Invalid translation author: $value. Using default: $DEFAULT_TRANSLATION_AUTHOR");
      value = DEFAULT_TRANSLATION_AUTHOR;
    }
    _translationAuthor = value;
  }

  String get reciterId => _reciterId;
  set reciterId(String value) {
    if (!RecitersData.allRecitations.any((a) => a.id == value)) {
      log("Invalid reciter name: $value. Using default: $DEFAULT_RECITATION");
      value = DEFAULT_RECITATION.id;
    }
    _reciterId = value;
  }

  AppSettings copyWith({
    double? quranFontSize,
    double? tafseerFontSize,
    double? appFontSize,
    String? fontFamily,
    bool? showTaranslation,
    String? translationAuthor,
    String? reciterId,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      quranFontSize: quranFontSize ?? _quranFontSize,
      translationFontSize: tafseerFontSize ?? _translationFontSize,
      appFontSize: appFontSize ?? _appFontSize,
      quranFontFamily: fontFamily ?? _quranFontFamily,
      showTaranslation: showTaranslation ?? _showTaranslation,
      translationAuthor: translationAuthor ?? _translationAuthor,
      reciterId: reciterId ?? _reciterId,
      themeMode: themeMode ?? _themeMode,
    );
  }
}
