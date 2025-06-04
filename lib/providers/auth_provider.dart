import 'package:flutter/material.dart';
import 'package:register_login/models/user_model.dart';
import 'package:register_login/services/auth_service.dart';
import 'package:register_login/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final ApiService _apiService;
  final SharedPreferences _prefs;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._apiService, this._prefs);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.login(username, password);
      
      // Lưu token
      final token = response['token'] as String;
      await _prefs.setString(StorageConstants.token, token);
      _apiService.token = token;

      // Lưu thông tin user
      _currentUser = User.fromJson(response['user']);

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

      await _apiService.register(userData);

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
    _apiService.token = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = _prefs.getString(StorageConstants.token);
    if (token != null) {
      _apiService.token = token;
      // TODO: Validate token with server and get user info
    }
    notifyListeners();
  }
}