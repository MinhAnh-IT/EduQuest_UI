import 'dart:io';
import 'package:flutter/material.dart';
import 'package:register_login/feature/auth/models/Profile_Model.dart';
import 'package:register_login/feature/auth/services/profile_service.dart';

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
    } catch (e) {
      _error = e.toString();
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
    } catch (e) {
      _error = e.toString();
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