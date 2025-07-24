import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//enum AppTheme { light, dark }
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadTheme(); // Load saved theme when app starts
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark); // Save theme state
  }






  //primitive obssesion(Replace Data Value with Object)


/*Future<void> toggleTheme(AppTheme theme) async {
  _themeMode = theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;
  notifyListeners();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('appTheme', theme.name);
  }


 */





  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
