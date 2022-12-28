import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Language {
  final String name;
  final String langCode;
  final String regionCode;
  const Language(this.name, this.langCode, this.regionCode);

  Locale toLocale() => Locale(langCode, regionCode);
}

Iterable<Language> languages = const [
  Language("English", "en", "US"),
  Language("繁體中文 (香港)", "zh", "HK"),
  Language("繁體中文 (台灣)", "zh", "TW"),
  Language("简体中文 (內地)", "zh", "CN"),
];

class LanguageProvider extends ChangeNotifier {
  Language currLanguage = languages.first;

  Iterable<Locale> get supportedLocales => languages.map((l) => l.toLocale());

  Iterable<Language> get supportedLanguages => languages;

  void updateLanguage(Language newLang) {
    currLanguage = newLang;
    notifyListeners();
  }
}
