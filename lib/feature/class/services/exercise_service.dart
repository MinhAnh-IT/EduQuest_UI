import 'dart:convert';
import '../models/assignment.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

class ExerciseService {
  Future<List<Assignment>> fetchExercises() async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.getExercisesForStudent}';
    final response = await ApiClient.get(url, auth: true);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> exercises = data['data'];
      return exercises.map((e) => Assignment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}