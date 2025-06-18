import 'dart:convert';
import 'package:register_login/config/api_config.dart';
import 'package:register_login/core/enums/status_code.dart';
import 'package:register_login/core/network/api_client.dart';
import 'package:register_login/feature/quiz/models/start_exam_model.dart';
import 'package:register_login/feature/quiz/models/submission_request.dart';
import 'package:register_login/feature/quiz/models/submited_model.dart';

class QuizService {
  static Future<StartExamModel> getQuestionsByExerciseId(int id) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.startExam}/$id/start';
    final response = await ApiClient.post(url, {});
    
    final Map<String, dynamic> body = jsonDecode(response.body);
    
    final int code = body['code'];
    
    final String message = body['message'] ?? '';
    if (code == StatusCode.ok.code) {
      final response = StartExamModel.fromJson(body['data']);
      return response;
    } else if (code == StatusCode.notFound.code) {
      throw Exception(StatusCode.notFound.formatMessage("bài tập"));
    } else if (code == StatusCode.notIsStudent.code) {
      throw Exception(StatusCode.notIsStudent.message);
    } else if(code == StatusCode.participationAlreadyExists.code){
      throw Exception(StatusCode.participationAlreadyExists.message);
    } else if (code == StatusCode.participationIsSubmitted.code){
      throw Exception(StatusCode.participationIsSubmitted.message);
    }else {
      throw Exception(message.isNotEmpty ? message : "Có lỗi xảy ra");
    }
  }

  static Future<SubmitedModel> submissionExam(SubmissionRequest request) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.submissionExam}';
    final response = await ApiClient.post(url, request.toJson());

    final Map<String, dynamic> body = jsonDecode(response.body);

    final code = body['code'];
    final message = body['message'];

    if(code == StatusCode.ok.code){
      return SubmitedModel.fromJson(body['data']);
    }else if(code == StatusCode.notMatch.code){
      throw Exception(StatusCode.notMatch.message);
    } else if(code == StatusCode.expiredExercise.code){
      throw Exception(StatusCode.expiredExercise.message);
    }else{
      throw Exception(message.isNotEmpty ? message : "Có lỗi xảy ra trong quá trình nộp bài");
    }
  }
}
