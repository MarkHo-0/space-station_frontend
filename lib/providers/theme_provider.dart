import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color darkPrimary = const Color(0xff6e7eb5);
Color lightPrimary = const Color(0xff93a5e2);

const _kDataKey = 'is_dark_theme';

class ThemeProvider extends ChangeNotifier {
  late SharedPreferences pref;
  bool isBlackTheme = false;

  ThemeProvider(this.pref) {
    final savedData = pref.getBool(_kDataKey);
    if (savedData != null) {
      isBlackTheme = savedData;
    }
  }

  void setTheme(bool newIsBlack) {
    if (newIsBlack == isBlackTheme) return;
    isBlackTheme = newIsBlack;
    pref.setBool(_kDataKey, newIsBlack);
    notifyListeners();
  }

  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: isBlackTheme ? Brightness.dark : Brightness.light,
      primaryColor: isBlackTheme ? lightPrimary : darkPrimary,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isBlackTheme ? lightPrimary : darkPrimary,
        selectionColor: isBlackTheme ? darkPrimary : lightPrimary,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: isBlackTheme ? lightPrimary : darkPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        backgroundColor: isBlackTheme ? null : Colors.white,
        foregroundColor: isBlackTheme ? lightPrimary : darkPrimary,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: isBlackTheme ? lightPrimary : darkPrimary,
          ),
        ),
        isDense: true,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (callback) => lightPrimary),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
          (callback) {
            if (callback.contains(MaterialState.selected)) return darkPrimary;
          },
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3), // <-- Radius
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: isBlackTheme ? lightPrimary : darkPrimary)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: isBlackTheme ? darkPrimary : lightPrimary,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
