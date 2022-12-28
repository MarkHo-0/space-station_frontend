import 'package:flutter/material.dart';

ThemeData whiteTheme = ThemeData(primaryColor: Colors.blue);
ThemeData darkTheme = ThemeData(primaryColor: Colors.blue, brightness: Brightness.dark);

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
