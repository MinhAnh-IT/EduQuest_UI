import 'package:edu_quest/core/enums/status_code.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../feature/auth/models/user_model.dart';
import '../../../feature/auth/services/auth_service.dart';
import '../../../shared/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
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

  void clearError() {
    _error = null;
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
      _setError('Yêu cầu đặt lại mật khẩu thất bại: $e');
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
      _setError('Đặt lại mật khẩu thất bại: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    _setLoading(true);
    try {
      final response = await _authService.logout();
      if (response['code'] == 200) {
        _token = null;
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
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
      _setError('Lỗi xác thực OTP: $e');
      return false;
    }
  }

  Future<bool> login(String username, String password, {VoidCallback? onUserNotVerified}) async {
    _setLoading(true);
    try {
      final response = await AuthService.login(username, password);
      if (response['code'] == 200) {
        final data = response['data'];
        _token = data['accessToken'];
        final refreshToken = data['refreshToken'];

        await _secureStorage.write(key: 'access_token', value: _token!);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);

        ApiClient.token = _token;
        _setLoading(false);
        return true;
      } else if (response['code'] == StatusCode.userNotVerified.code) {
        _setLoading(false);
        if (onUserNotVerified != null) onUserNotVerified();
        return false;
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

      if (response['code'] == 201) {
        final data = response['data'] as Map<String, dynamic>;
        final userId = data['id'] as int;
        await _prefs.setInt(StorageConstants.tempUserId, userId);
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Đăng ký thất bại');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Đăng ký thất bại: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String username, String otp) async {
    _setLoading(true);
    try {
      final response = await AuthService.verifyOtp(username, otp);

      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        String errorMessage = response['message'] ?? 'Xác thực OTP thất bại';
        if (errorMessage.contains('Invalid or expired OTP')) {
          errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
        }
        _setError(errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      if (errorMessage.contains('Invalid or expired OTP')) {
        errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateStudentDetails(
      int userId, Map<String, dynamic> details) async {
    _setLoading(true);
    try {
      final response = await AuthService.updateStudentDetails(userId, details);
      if (response['code'] == 201) {
        _setLoading(false);
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Cập nhật thông tin thất bại: $e');
      return false;
    }
  }

  Future<void> resendOTP(String username) async {
    try {
      await AuthService.resendOtp(username);
    } catch (e) {
      _setError('Gửi lại mã OTP thất bại: $e');
    }
  }

  Future<void> checkAuthStatus() async {
    _token = await _secureStorage.read(key: 'access_token');
    if (_token != null) {
      ApiClient.token = _token;
    }
    notifyListeners();
  }
}