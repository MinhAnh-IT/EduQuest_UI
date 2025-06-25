import 'dart:convert';
import 'package:edu_quest/config/api_config.dart';
import 'package:edu_quest/core/enums/status_code.dart';
import 'package:edu_quest/core/network/api_client.dart';
import 'package:edu_quest/feature/discussion/models/discussion_model.dart';

class DiscussionApiService {
  Future<List<Discussion>> fetchDiscussionsByExercise(int exerciseId) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.getDiscussionsByExerciseId}/$exerciseId';
    final response = await ApiClient.get(url, auth: true);
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['code'] == StatusCode.ok.code) {
      return (body['data'] as List).map((e) => Discussion.fromJson(e)).toList();
    }
    throw Exception(body['message'] ?? "Có lỗi xảy ra khi lấy thảo luận");
  }

  Future<Discussion> createDiscussion(int exerciseId, String content) async {
    final url = '${ApiConfig.baseUrl}/discussions';
    final body = {
      'exerciseId': exerciseId,
      'content': content,
    };
    final response = await ApiClient.post(url, body, auth: true);
    final Map<String, dynamic> resBody = jsonDecode(response.body);

    if (resBody['code'] == 200) {
      return Discussion.fromJson(resBody['data']);
    } else if (resBody['code'] == StatusCode.exerciseNotExpiredYet.code) {
      throw Exception(StatusCode.exerciseNotExpiredYet.message);
    } else if (resBody['code'] == StatusCode.exerciseNotFound.code) {
      throw Exception(StatusCode.exerciseNotFound.message);
    } 
    else {
      throw Exception(resBody['message'] ?? 'Có lỗi xảy ra khi tạo thảo luận!');
    }
  }

  Future<Discussion> editDiscussion(String discussionId, String newContent) async {
    final url = '${ApiConfig.baseUrl}/discussions/$discussionId';
    final response = await ApiClient.put(
      url,
      {'content': newContent},
      auth: true,
    );
    final body = jsonDecode(response.body);
    if (body['code'] == StatusCode.ok.code && body['data'] != null) {
      return Discussion.fromJson(body['data']);
    } else {
      throw Exception(body['message'] ?? 'Cập nhật thảo luận thất bại');
    }
  }

  Future<bool> deleteDiscussion(String discussionId) async {
    final url = '${ApiConfig.baseUrl}/discussions/$discussionId';
    final response = await ApiClient.delete(url, auth: true);
    final body = jsonDecode(response.body);
    if (body['code'] == 200 && body['data'] == true) {
      return true;
    } else {
      throw Exception(body['message'] ?? 'Xoá thảo luận thất bại');
    }
  }
}
