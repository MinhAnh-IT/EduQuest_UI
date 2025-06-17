import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register_login/core/network/api_client.dart';
import 'package:register_login/feature/auth/models/user_model.dart';
import 'package:register_login/feature/auth/services/auth_service.dart';
import 'package:register_login/shared/utils/constants.dart';
import 'package:register_login/feature/auth/models/auth_user.dart';


class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final AuthService _authService = AuthService();
  AuthUser? _user;
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
  }  Future<bool> requestPasswordReset(String username) async {
    _setLoading(true);
    try {
      final response = await _authService.requestPasswordReset(username);
      
      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        // Handle specific error codes with Vietnamese messages
        String errorMessage;
        switch (response['code']) {
          case 430:
            errorMessage = 'Không tìm thấy tài khoản với tên đăng nhập này. Vui lòng kiểm tra lại.';
            break;
          case 501:
            errorMessage = 'Không thể gửi email OTP. Vui lòng thử lại sau.';
            break;
          default:
            errorMessage = response['message'] ?? 'Yêu cầu đặt lại mật khẩu thất bại. Vui lòng thử lại.';
        }
        _setError(errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.');
      return false;
    }
  }
    Future<bool> resetPassword(String username, String newPassword) async {
    _setLoading(true);
    try {
      final response = await _authService.resetPassword(username, newPassword);
      print('AuthProvider - Reset password response: $response'); // Debug log
      
      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        // Handle specific error codes with Vietnamese messages
        String errorMessage;
        switch (response['code']) {
          case 404:
            errorMessage = 'Cần xác minh OTP trước khi đặt lại mật khẩu. Vui lòng xác minh OTP trước.';
            break;
          case 430:
            errorMessage = 'Không tìm thấy tài khoản. Vui lòng kiểm tra tên đăng nhập.';
            break;
          case 450:
            errorMessage = 'Mật khẩu không đúng định dạng. Mật khẩu phải đáp ứng yêu cầu bảo mật.';
            break;
          default:
            errorMessage = response['message'] ?? 'Đặt lại mật khẩu thất bại. Vui lòng thử lại.';
        }
        _setError(errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.');
      return false;
    }
  }
  
  Future<bool> logout() async {
    _setLoading(true);
    try {
      final response = await _authService.logout();
      if (response['code'] == 200) {
        _user = null;
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
    }  }
  
  Future<bool> verifyOTPForgotPassword(String username, String otp) async {
    _setLoading(true);
    try {
      final response = await _authService.verifyOTPForgotPassword(username, otp);
      
      if (response['code'] == 200) {
        _setLoading(false);
        return true;
      } else {
        // Handle specific error codes with Vietnamese messages
        String errorMessage;
        switch (response['code']) {
          case 403:
            errorMessage = 'OTP không đúng hoặc đã hết hạn. Vui lòng yêu cầu OTP mới.';
            break;
          case 430:
            errorMessage = 'Không tìm thấy tài khoản. Vui lòng kiểm tra tên đăng nhập.';
            break;
          default:
            errorMessage = response['message'] ?? 'Xác minh OTP thất bại. Vui lòng thử lại.';
        }
        _setError(errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.');
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
        //_currentUser = User.fromJson(data['user']);
        //print(_currentUser);
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