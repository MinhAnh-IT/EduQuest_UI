import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:register_login/services/api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService apiService;
  String? _verificationId;
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false;

  AuthService({required this.apiService});

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVerified => _isVerified;

  // Giả lập gửi OTP qua email
  Future<bool> sendOTP(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Giả lập API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Tạo mã OTP ngẫu nhiên 6 số
      final otp = Random().nextInt(900000) + 100000;
      _verificationId = otp.toString();
      
      print('OTP sent: $_verificationId'); // Trong thực tế sẽ gửi qua email

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
  Future<bool> verifyOTP(String otp) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Giả lập API call
      await Future.delayed(const Duration(seconds: 1));

      if (otp == _verificationId) {
        _isVerified = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Mã OTP không chính xác';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Lỗi xác thực: $e';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _verificationId = null;
    _isLoading = false;
    _error = null;
    _isVerified = false;
    notifyListeners();
  }
} 