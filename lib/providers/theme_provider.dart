import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  bool _isDarkMode = false;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  void _loadTheme() {
    _isDarkMode = _prefs.getBool(StorageConstants.theme) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(StorageConstants.theme, _isDarkMode);
    notifyListeners();
  }

  // Có thể thêm các phương thức để tùy chỉnh màu sắc, font chữ, v.v.
  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4A90E2),
    scaffoldBackgroundColor: const Color(0xFFF7FAFC),
    // Thêm các thuộc tính theme khác
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4A90E2),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    // Thêm các thuộc tính theme khác
  );
} 