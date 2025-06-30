import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edu_quest/feature/Profile/models/Profile_Model.dart';
import 'package:edu_quest/feature/Profile/services/profile_service.dart';
import 'package:edu_quest/core/exceptions/auth_exception.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await ProfileService.getCurrentUser();
    } on AuthException {
      _error = 'Yêu cầu xác thực';
      // Có thể thêm logic để clear tokens và redirect về login
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        _error = errorMessage.replaceFirst('Exception: ', '');
      } else {
        _error = 'Đã xảy ra lỗi không mong muốn';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String email, File? avatarFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await ProfileService.updateProfile(email, avatarFile);
      return true;
    } on AuthException {
      _error = 'Yêu cầu xác thực';
      return false;
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        _error = errorMessage.replaceFirst('Exception: ', '');
      } else {
        _error = 'Đã xảy ra lỗi không mong muốn';
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}