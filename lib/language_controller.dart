/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  Locale _currentLocale = const Locale('en'); // Default is English

  Locale get currentLocale => _currentLocale;

  LanguageController() {
    _loadSavedLanguage();
  }

  void changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selectedLanguage');
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }
}


 */
