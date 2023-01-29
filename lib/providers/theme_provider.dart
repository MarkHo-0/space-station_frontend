import 'package:flutter/material.dart';

Color darkPrimary = const Color(0xff6e7eb5);
Color lightPrimary = const Color(0xff93a5e2);

class ThemeProvider extends ChangeNotifier {
  bool isBlackTheme = false;

  void setTheme(bool isBack) {
    isBlackTheme = isBack;
    notifyListeners();
  }

  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: isBlackTheme ? Brightness.dark : Brightness.light,
      primaryColor: isBlackTheme ? lightPrimary : darkPrimary,
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
      switchTheme: isBlackTheme
          ? SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (callback) => lightPrimary),
              trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (callback) => darkPrimary),
            )
          : null,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: isBlackTheme ? darkPrimary : lightPrimary,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
