import 'dart:convert';

import 'package:edu_quest/feature/discussion/models/discussion_comment_model.dart';
import 'package:edu_quest/feature/discussion/services/discussion_comment_service.dart';
import 'package:flutter/foundation.dart';

class DiscussionCommentProvider extends ChangeNotifier {
  final DiscussionCommentApiService api;
  final int discussionId;
  StompClient? _stompClient;

  List<DiscussionComment> comments = [];
  bool loading = false;
  String? errorMessage;

  DiscussionCommentProvider({required this.api, required this.discussionId});

  Future<void> loadComments() async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      comments = await api.fetchComments(discussionId);
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  void connectWebSocket(String wsUrl) {
    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: wsUrl,
        onConnect: (StompFrame frame) {
          _stompClient!.subscribe(
            destination: '/topic/discussion/$discussionId',
            callback: (frame) {
              if (frame.body != null) {
                final data = jsonDecode(frame.body!);

                if (data['type'] == 'LIKE') {
                  int commentId = data['discussionCommentId'];
                  int newLikeCount = data['likeCount'];
                  int idx = comments.indexWhere((c) => c.id == commentId);
                  if (idx != -1) {
                    comments[idx] = comments[idx].copyWith(voteCount: newLikeCount);
                    notifyListeners();
                  }
                  return;
                }

                if (data['discussionId'] == discussionId) {
                  final newComment = DiscussionComment.fromJson(data);
                  if (!comments.any((c) => c.id == newComment.id)) {
                    comments.add(newComment);
                    notifyListeners();
                  }
                }
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    _stompClient!.activate();
  }

  void sendComment(String content, int currentUserId) {
    if (_stompClient != null && _stompClient!.connected) {
      final message = jsonEncode({
        'discussionId': discussionId,
        'content': content,
        'createdBy': currentUserId,
      });
      _stompClient!.send(
        destination: '/app/discussion.comment',
        body: message,
      );
    }
  }

  void sendLike(int discussionCommentId, bool isUpvote) {
    if (_stompClient != null && _stompClient!.connected) {
      final message = jsonEncode({
        'discussionCommentId': discussionCommentId,
        'isUpvote': isUpvote,
      });
      _stompClient!.send(
        destination: '/app/discussion.like',
        body: message,
      );
    }
  }

  @override
  void dispose() {
    _stompClient?.deactivate();
    super.dispose();
  }
}
