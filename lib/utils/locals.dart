import 'package:flutter/material.dart';

class MyLocale {
  final String name;
  final Locale locale;

  const MyLocale(this.name, this.locale);
}

const kSupportedLocales = [
  MyLocale("English", Locale("en")),
  MyLocale("繁體中文 (香港)", Locale("zh", "HK")),
  MyLocale("繁體中文 (台灣)", Locale("zh", "TW")),
  MyLocale("简体中文 (內地)", Locale("zh", "CN")),
];
