import 'package:flutter/material.dart';
import 'package:register_login/models/user_model.dart';
import 'package:register_login/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final SharedPreferences _prefs;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._prefs);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Giả lập đăng nhập thành công
      _currentUser = User(
        username: username,
        name: 'Người dùng',
        role: UserRole.STUDENT,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Lưu token vào SharedPreferences
      await _prefs.setString(StorageConstants.token, 'fake_token');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Đăng nhập thất bại: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Đăng ký thất bại: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs.remove(StorageConstants.token);
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = _prefs.getString(StorageConstants.token);
    if (token != null) {
      // TODO: Validate token with server
      // For now, just set a dummy user
      _currentUser = User(
        username: 'user',
        name: 'Người dùng',
        role: UserRole.STUDENT,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    notifyListeners();
  }
}