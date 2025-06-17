import 'dart:convert';
import 'package:register_login/config/api_config.dart';
import 'package:register_login/core/enums/status_code.dart';
import 'package:register_login/core/network/api_client.dart';
import '../models/question_model.dart';

class QuizService {
  static Future<List<QuestionModel>> getQuestionsByExerciseId(int id) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.getQuestionForExercise}/$id';
    final response = await ApiClient.get(url);
    final Map<String, dynamic> body = jsonDecode(response.body);

    final int code = body['code'];
    final String message = body['message'] ?? '';

    if (code == StatusCode.notFound.code) {
      throw Exception(StatusCode.notFound.formatMessage("bài tập"));
    } else if (code == 200) {
      final List<QuestionModel> questions =
          (body['data'] as List).map((e) => QuestionModel.fromJson(e)).toList();
      return questions;
    } else {
      throw Exception(message.isNotEmpty ? message : "Có lỗi xảy ra");
    }
  }
}
