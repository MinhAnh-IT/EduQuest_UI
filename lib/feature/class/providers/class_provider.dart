import 'package:flutter/material.dart';
import '../models/class_detail.dart';
import '../models/student.dart';
import '../services/class_service.dart';
import '../../../core/enums/status_code.dart';

class ClassProvider extends ChangeNotifier {
  final ClassService _classService = ClassService();

  // Class detail state
  ClassDetail? _classDetail;
  bool _isLoadingClassDetail = false;
  String? _classDetailError;

  // Students state
  List<Student> _students = [];
  bool _isLoadingStudents = false;
  String? _studentsError;

  // Getters
  ClassDetail? get classDetail => _classDetail;
  bool get isLoadingClassDetail => _isLoadingClassDetail;
  String? get classDetailError => _classDetailError;

  List<Student> get students => _students;
  bool get isLoadingStudents => _isLoadingStudents;
  String? get studentsError => _studentsError;

  // Helper getters
  int get studentsCount => _students.length;
  List<Student> get enrolledStudents => 
      _students.where((student) => student.enrollmentStatus.toUpperCase() == 'ENROLLED').toList();
  List<Student> get pendingStudents => 
      _students.where((student) => student.enrollmentStatus.toUpperCase() == 'PENDING').toList();
  List<Student> get rejectedStudents => 
      _students.where((student) => student.enrollmentStatus.toUpperCase() == 'REJECTED').toList();  // Load class detail
  Future<void> loadClassDetail(int classId) async {
    _isLoadingClassDetail = true;
    _classDetailError = null;
    notifyListeners();

    try {
      final response = await _classService.getClassDetail(classId);
      
      if (response.status == StatusCode.ok && response.data != null) {
        _classDetail = response.data;
        _classDetailError = null;
      } else {
        _classDetailError = response.message;
      }
    } catch (e) {
      _classDetailError = 'Không thể tải thông tin lớp học: $e';
    } finally {
      _isLoadingClassDetail = false;
      notifyListeners();
    }
  }  // Load students in class
  Future<void> loadStudents(int classId) async {
    _isLoadingStudents = true;
    _studentsError = null;
    notifyListeners();

    try {
      final response = await _classService.getStudentsInClass(classId);
      
      if (response.status == StatusCode.ok && response.data != null) {
        _students = response.data!;
        _studentsError = null;
      } else {
        _studentsError = response.message;
      }
    } catch (e) {
      _studentsError = 'Không thể tải danh sách học sinh: $e';
    } finally {
      _isLoadingStudents = false;
      notifyListeners();
    }
  }

  // Refresh class detail
  Future<void> refreshClassDetail(int classId) async {
    await loadClassDetail(classId);
  }

  // Refresh students
  Future<void> refreshStudents(int classId) async {
    await loadStudents(classId);
  }

  // Load both class detail and students
  Future<void> loadClassData(int classId) async {
    await Future.wait([
      loadClassDetail(classId),
      loadStudents(classId),
    ]);
  }

  // Clear class detail error
  void clearClassDetailError() {
    _classDetailError = null;
    notifyListeners();
  }

  // Clear students error
  void clearStudentsError() {
    _studentsError = null;
    notifyListeners();
  }

  // Clear all errors
  void clearAllErrors() {
    _classDetailError = null;
    _studentsError = null;
    notifyListeners();
  }

  // Reset all state
  void reset() {
    _classDetail = null;
    _isLoadingClassDetail = false;
    _classDetailError = null;
    
    _students = [];
    _isLoadingStudents = false;
    _studentsError = null;
    
    notifyListeners();
  }

  // Filter students by status
  List<Student> getStudentsByStatus(String status) {
    return _students.where((student) => 
        student.enrollmentStatus.toUpperCase() == status.toUpperCase()).toList();
  }

  // Search students by name
  List<Student> searchStudents(String query) {
    if (query.isEmpty) return _students;
    
    return _students.where((student) =>
        student.studentName.toLowerCase().contains(query.toLowerCase()) ||
        student.studentCode.toLowerCase().contains(query.toLowerCase()) ||
        student.studentEmail.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get student by ID
  Student? getStudentById(int studentId) {
    try {
      return _students.firstWhere((student) => student.studentId == studentId);
    } catch (e) {
      return null;
    }
  }
  // Set initial class detail (useful when navigating from class list with existing data)
  void setInitialClassDetail(ClassDetail classDetail) {
    _classDetail = classDetail;
    _classDetailError = null;
    _isLoadingClassDetail = false;
    notifyListeners();
  }
}
