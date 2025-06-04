import 'package:flutter/material.dart';
import 'package:register_login/models/student_model.dart';

class StudentProvider extends ChangeNotifier {
  Student? _studentDetails;
  bool _isLoading = false;
  String? _error;

  Student? get studentDetails => _studentDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> saveStudentDetails(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      _studentDetails = Student(
        userId: data['userId'],
        studentCode: data['studentCode'],
        faculty: data['faculty'],
        enrolledYear: int.parse(data['enrolledYear']),
        birthDate: data['birthDate'],
      );

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

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Giả lập dữ liệu
      _studentDetails = Student(
        userId: userId,
        studentCode: 'SV001',
        faculty: 'Công nghệ thông tin',
        enrolledYear: 2023,
        birthDate: DateTime(2000, 1, 1),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Không thể tải thông tin sinh viên: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _studentDetails = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
} 