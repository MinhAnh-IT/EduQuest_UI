import 'dart:convert';
import 'package:edu_quest/config/api_config.dart';
import 'package:edu_quest/core/network/api_client.dart';
import 'package:edu_quest/feature/discussion/models/discussion_comment_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DiscussionCommentApiService {
  Future<List<DiscussionComment>> fetchComments(int discussionId) async {
    final url = '${ApiConfig.baseUrl}/discussions/$discussionId/comments';
    final response = await ApiClient.get(url, auth: true);
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (body['code'] == 200) {
      return (body['data'] as List)
          .map((e) => DiscussionComment.fromJson(e))
          .toList();
    }
    throw Exception(body['message'] ?? "Có lỗi xảy ra khi lấy bình luận");
  }

  void sendComment({
    required WebSocketChannel channel,
    required int discussionId,
    required String content,
    required int createdBy,
  }) {
    final message = jsonEncode({
      'discussionId': discussionId,
      'content': content,
      'createdBy': createdBy,
    });
    channel.sink.add(message);
  }
}
