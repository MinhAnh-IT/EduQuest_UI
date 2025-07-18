import 'dart:convert';
import '../models/assignment.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

class ExerciseService {
  Future<List<Assignment>> fetchExercises(int classId) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.getExercisesForStudent}/$classId';
    final response = await ApiClient.get(url, auth: true);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> exercises = data['data'];
      return exercises.map((e) => Assignment.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải danh sách bài tập');
    }
  }
}
