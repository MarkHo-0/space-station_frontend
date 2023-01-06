import 'package:flutter/material.dart';

Color primaryColor = const Color(0xff6e7eb5);

ThemeData whiteTheme = ThemeData(primaryColor: primaryColor);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((_) => primaryColor),
    trackColor: MaterialStateProperty.resolveWith<Color?>((_) => primaryColor.withAlpha(150)),
  ),
  navigationBarTheme: NavigationBarThemeData(indicatorColor: primaryColor),
);

class ThemeProvider extends ChangeNotifier {
  bool isBlackTheme = false;

  void setTheme(bool isBack) {
    isBlackTheme = isBack;
    notifyListeners();
  }

  ThemeData get theme {
    return isBlackTheme ? darkTheme : whiteTheme;
  }
}
