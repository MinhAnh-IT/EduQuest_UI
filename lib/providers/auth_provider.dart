import 'package:flutter/material.dart';
import '../models/auth_user.dart';
import '../models/api_response.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthUser? _user;
  bool _isLoading = false;

  AuthUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authService.getStoredUser();

    _isLoading = false;
    notifyListeners();
  }
  Future<ApiResponse<void>> requestPasswordReset(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.requestPasswordReset(username);
      return response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponse<void>> resetPassword(String username, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.resetPassword(username, newPassword);
      return response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponse> verifyOTP(String username, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.verifyOTP(username, otp);
      return response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
