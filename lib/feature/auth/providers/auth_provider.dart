import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/core/network/api_client.dart';
import 'package:register_login/feature/auth/models/user_model.dart';
import 'package:register_login/feature/auth/services/auth_service.dart';
import 'package:register_login/shared/utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

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

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      final response = await AuthService.login(username, password);
      if (response['code'] == 200) {
        final data = response['data'];
        _token = data['accessToken'];
        _currentUser = User.fromJson(data['user']);
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
      
      // Kiểm tra response thành công với code 201 (CREATED)
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
      print('Verify OTP response: $response');

      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        String errorMessage = response['message'] ?? 'Xác thực OTP thất bại';
        // Thêm lại logic dịch thuật
        if (errorMessage.contains('Invalid or expired OTP')) {
          errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
        }
        _setError(errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Error in verifyOTP: $e');
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      // Thêm lại logic dịch thuật cho trường hợp exception
      if (errorMessage.contains('Invalid or expired OTP')) {
        errorMessage = 'Mã OTP không hợp lệ hoặc đã hết hạn';
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateStudentDetails(int userId, Map<String, dynamic> details) async {
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

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    ApiClient.token = null;
    await _prefs.remove(StorageConstants.token);
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _token = _prefs.getString(StorageConstants.token);
    if (_token != null) {
      ApiClient.token = _token;
    }
    notifyListeners();
  }
}
