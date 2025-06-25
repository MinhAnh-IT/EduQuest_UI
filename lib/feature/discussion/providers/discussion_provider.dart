import 'package:flutter/foundation.dart';
import 'package:edu_quest/feature/discussion/models/discussion_model.dart';
import 'package:edu_quest/feature/discussion/services/discussion_service.dart';

class DiscussionProvider extends ChangeNotifier {
  final DiscussionApiService api;
  DiscussionProvider({required this.api});

  List<Discussion> discussions = [];
  bool loading = false;
  String? errorMessage;

  Future<void> loadDiscussionsByExercise(int exerciseId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      discussions = await api.fetchDiscussionsByExercise(exerciseId);
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addDiscussion(int exerciseId, String content) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final discussion = await api.createDiscussion(exerciseId, content);
      discussions.insert(0, discussion);
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> editDiscussion(String discussionId, String newContent) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final updated = await api.editDiscussion(discussionId, newContent);
      final idx = discussions.indexWhere((d) => d.id.toString() == discussionId);
      if (idx != -1) {
        discussions[idx] = updated;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> deleteDiscussion(String discussionId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final ok = await api.deleteDiscussion(discussionId);
      if (ok) {
        discussions.removeWhere((d) => d.id.toString() == discussionId);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
