import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/core/network/api_client.dart';
import 'package:register_login/feature/auth/models/user_model.dart';
import 'package:register_login/feature/auth/services/auth_service.dart';
import 'package:register_login/shared/utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _token;

  AuthProvider(this._prefs);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> requestPasswordReset(String username) async {
    _setLoading(true);
    try {
      final response = await _authService.requestPasswordReset(username);

      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng thử lại.');
      return false;
    }
  }

  Future<bool> resetPassword(String username, String newPassword) async {
    _setLoading(true);
    try {
      final response = await _authService.resetPassword(username, newPassword);
      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng thử lại.');
      return false;
    }
  }

  Future<bool> logout() async {
    _setLoading(true);
    try {
      final response = await _authService.logout();
      if (response['code'] == 200) {
        _token = null;
        await _prefs.remove(StorageConstants.token);
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Đăng xuất thất bại: $e');
      return false;
    }
  }

  Future<bool> verifyOTPForgotPassword(String username, String otp) async {
    _setLoading(true);
    try {
      final response =
          await _authService.verifyOTPForgotPassword(username, otp);
      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng thử lại.');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      final response = await AuthService.login(username, password);
      if (response['code'] == 200) {
        final data = response['data'];
        _token = data['accessToken'];
        await _prefs.setString(StorageConstants.token, _token!);
        ApiClient.token = _token;
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Đăng nhập thất bại: $e');
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> payload) async {
    _setLoading(true);
    try {
      final response = await AuthService.register(payload);
      if (response['code'] == 0) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Đăng ký thất bại: $e');
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    _setLoading(true);
    try {
      final response = await AuthService.verifyOtp(email, otp);
      if (response['code'] == 0) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Lỗi xác thực OTP: $e');
      return false;
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      await AuthService.resendOtp(email);
    } catch (e) {
      _setError('Gửi lại mã OTP thất bại: $e');
    }
  }

  Future<void> checkAuthStatus() async {
    _token = _prefs.getString(StorageConstants.token);
    if (_token != null) {
      ApiClient.token = _token;
    }
    notifyListeners();
  }
}
