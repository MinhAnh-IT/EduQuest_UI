import 'package:flutter/material.dart';
import 'package:register_login/models/student_model.dart';
import 'package:register_login/services/api_service.dart';

class StudentProvider extends ChangeNotifier {
  final ApiService _apiService;
  Student? _studentDetails;
  bool _isLoading = false;
  String? _error;

  StudentProvider(this._apiService);

  Student? get studentDetails => _studentDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> saveStudentDetails(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _studentDetails = await _apiService.saveStudentDetails(data);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Không thể lưu thông tin sinh viên: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchStudentDetails(int userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _studentDetails = await _apiService.getStudentDetails(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Không thể tải thông tin sinh viên: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStudentDetails(int userId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _studentDetails = await _apiService.updateStudentDetails(userId, data);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Không thể cập nhật thông tin sinh viên: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _studentDetails = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
} 