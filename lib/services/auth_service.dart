import 'package:flutter/material.dart';
import 'package:register_login/services/api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService apiService;
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false;

  AuthService({required this.apiService});

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVerified => _isVerified;

  // Gửi OTP qua email
  Future<bool> sendOTP(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Gọi API để gửi OTP
      await apiService.resendOtp(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Không thể gửi mã OTP: $e';
      notifyListeners();
      return false;
    }
  }

  // Xác thực OTP
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Gọi API để xác thực OTP
      final result = await apiService.verifyOtp(email, otp);
      
      _isVerified = result;
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _error = 'Lỗi xác thực: $e';
      notifyListeners();
      return false;
    }
  }

  // Đăng ký tài khoản
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Gọi API đăng ký
      await apiService.register(userData);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Đăng ký thất bại: $e';
      notifyListeners();
      return false;
    }
  }

  // Đăng nhập
  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Gọi API đăng nhập
      final response = await apiService.login(username, password);
      
      // Cập nhật token trong ApiService
      apiService.token = response['token'] as String;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Đăng nhập thất bại: $e';
      notifyListeners();
      return false;
    }
  }

  // Reset trạng thái
  void reset() {
    _isLoading = false;
    _error = null;
    _isVerified = false;
    notifyListeners();
  }
}