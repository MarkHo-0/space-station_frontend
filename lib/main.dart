import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:space_station/api/http.dart';
import 'package:space_station/providers/auth_provider.dart';
import 'package:space_station/providers/theme_provider.dart';
import 'package:space_station/utils/locals.dart';
import 'package:space_station/views/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient.init(ClientConfig(
    shouldUseFakeData: false,
  ));

  //讀取本地設定
  final pref = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((_) => ThemeProvider()), lazy: false),
      ChangeNotifierProvider(create: ((_) => AuthProvider(pref)), lazy: false)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return EzLocalizationBuilder(
      delegate: EzLocalizationDelegate(
          supportedLocales:
              kSupportedLocales.map((l) => l.locale).toList(growable: false),
          getPathFunction: (locale) =>
              'assets/languages/${locale.toLanguageTag()}.json'),
      builder: (context, ezLocalizationDelegate) {
        return MaterialApp(
          title: 'Space Station',
          theme: Provider.of<ThemeProvider>(context).theme,
          locale: ezLocalizationDelegate.locale,
          supportedLocales: ezLocalizationDelegate.supportedLocales,
          localizationsDelegates: ezLocalizationDelegate.localizationDelegates,
          home: const ApplicationContainer(),
        );
      },
    );
  }
}
