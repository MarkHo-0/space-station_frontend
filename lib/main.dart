import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_station/api/http.dart';
import 'package:space_station/providers/auth_provider.dart';
import 'package:space_station/providers/localization_provider.dart';
import 'package:space_station/providers/theme_provider.dart';
import 'package:space_station/views/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient.init(ClientConfig(
    shouldUseFakeData: true,
    host: '192.168.128.143',
  ));

  //讀取本地設定
  final pref = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((_) => ThemeProvider())),
      ChangeNotifierProvider(create: ((_) => LanguageProvider())),
      ChangeNotifierProvider(create: ((_) => AuthProvider(pref)))
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
