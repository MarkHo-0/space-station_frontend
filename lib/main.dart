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
  HttpClient.init(ClientConfig());

  //讀取本地設定
  final pref = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((_) => ThemeProvider(pref)), lazy: false),
      ChangeNotifierProvider(create: ((_) => AuthProvider(pref)), lazy: false)
    ],
    child: MyApp(locale: getSavedLocale(pref)),
  ));
}

class MyApp extends StatefulWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return EzLocalizationBuilder(
      delegate: EzLocalizationDelegate(
        supportedLocales: kSupportedLocales,
        getPathFunction: getLocalePath,
        locale: widget.locale,
      ),
      builder: (context, delegate) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Space Station',
          theme: Provider.of<ThemeProvider>(context).theme,
          locale: delegate.locale,
          supportedLocales: delegate.supportedLocales,
          localizationsDelegates: delegate.localizationDelegates,
          home: const ApplicationContainer(),
        );
      },
    );
  }
}
