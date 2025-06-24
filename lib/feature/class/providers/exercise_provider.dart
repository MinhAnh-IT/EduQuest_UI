import 'package:flutter/material.dart';
import '../services/exercise_service.dart';
import '../models/assignment.dart';

class ExerciseProvider with ChangeNotifier {
  final ExerciseService _service = ExerciseService();
  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String? _error;

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAssignments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final exercises = await _service.fetchExercises();
      // Nếu exercises đã là List<Assignment>:
      _assignments = exercises;
      // Nếu exercises là List<Map<String, dynamic>>:
      // _assignments = exercises.map((e) => Assignment.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}