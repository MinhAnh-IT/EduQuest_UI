// providers/discussion_provider.dart

import 'package:edu_quest/feature/discussion/models/discussion_model.dart';
import 'package:edu_quest/feature/discussion/services/discussion_service.dart';
import 'package:flutter/foundation.dart';

class DiscussionProvider extends ChangeNotifier {
  final DiscussionApiService api;
  DiscussionProvider({required this.api});

  List<Discussion> discussions = [];
  List<DiscussionComment> comments = [];
  bool loading = false;

  // Load discussion theo bài tập
  Future<void> loadDiscussionsByExercise(int exerciseId) async {
    loading = true;
    notifyListeners();
    discussions = await api.fetchDiscussionsByExercise(exerciseId);
    loading = false;
    notifyListeners();
  }

  Future<void> addDiscussion(
      int exerciseId, String title, String authorName) async {
    discussions.add(
      Discussion(
        id: DateTime.now().toString(),
        exerciseId: exerciseId,
        title: title,
        authorName: authorName,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadComments(String discussionId) async {
    loading = true;
    notifyListeners();
    comments = await api.fetchComments(discussionId);
    loading = false;
    notifyListeners();
  }

  Future<void> addComment(String discussionId, String content) async {
    await api.postComment(discussionId, content);
    comments.insert(
      0,
      DiscussionComment(
        id: DateTime.now().toString(),
        discussionId: discussionId,
        authorName: "Bạn",
        avatarUrl: "https://i.pravatar.cc/40?img=4",
        content: content,
        createdAt: DateTime.now(),
        votes: 0,
      ),
    );
    notifyListeners();
  }
}
