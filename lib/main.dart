import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:space_station/providers/localization_provider.dart';
import 'package:space_station/providers/theme_provider.dart';
import 'package:space_station/views/application.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => ThemeProvider())),
      ChangeNotifierProvider(create: ((context) => LanguageProvider())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/localization'];
    LanguageProvider langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Space Station',
      theme: Provider.of<ThemeProvider>(context).theme,
      localizationsDelegates: [
        LocalJsonLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: langProvider.currLanguage.toLocale(),
      supportedLocales: langProvider.supportedLocales,
      home: const ApplicationContainer(),
    );
  }
}
