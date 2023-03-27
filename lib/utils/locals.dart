import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kDataKey = 'lang';

class Language {
  final String name;
  final Locale locale;

  const Language(this.name, this.locale);
}

const kSupportedLanguages = [
  Language("English", Locale("en")),
  Language("繁體中文 (香港)", Locale("zh", "HK")),
  Language("繁體中文 (台灣)", Locale("zh", "TW")),
  Language("简体中文 (內地)", Locale("zh", "CN")),
];

final kSupportedLocales =
    kSupportedLanguages.map((l) => l.locale).toList(growable: false);

String getLocalePath(Locale locale) {
  return 'assets/languages/${locale.toLanguageTag()}.json';
}

Locale getSavedLocale(SharedPreferences pref) {
  final data = pref.getString(_kDataKey);
  return kSupportedLocales.firstWhere(
    (l) => l.toLanguageTag() == data,
    orElse: () => kSupportedLocales.first,
  );
}

void saveLocale(Locale locale) {
  SharedPreferences.getInstance().then((pref) {
    pref.setString(_kDataKey, locale.toLanguageTag());
  });
}
