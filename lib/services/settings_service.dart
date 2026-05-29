import 'package:flutter/material.dart';

/// Global Settings Provider so any screen can read/write theme settings globally.
class SettingsProvider extends ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();

  factory SettingsProvider() => _instance;

  SettingsProvider._internal();

  bool _isDarkMode = false;
  double _fontScale = 1.0;
  String _appIcon = 'Default';

  // Getters
  static bool get isDarkMode => _instance._isDarkMode;
  static double get fontScale => _instance._fontScale;
  static String get appIcon => _instance._appIcon;

  // Setters
  static void setDarkMode(bool val) {
    _instance._isDarkMode = val;
    _instance.notifyListeners();
  }

  static void setFontScale(double val) {
    _instance._fontScale = val;
    _instance.notifyListeners();
  }

  static void setAppIcon(String val) {
    _instance._appIcon = val;
    _instance.notifyListeners();
  }
}