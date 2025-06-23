import 'package:edu_quest/feature/discussion/models/discussion_model.dart';

class DiscussionApiService {
  final _mockDiscussions = [
    Discussion(
      id: "1",
      exerciseId: 101,
      title: "Nộp muộn bị trừ điểm không?",
      authorName: "Lan",
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Discussion(
      id: "2",
      exerciseId: 101,
      title: "Đáp án đúng là gì vậy mọi người?",
      authorName: "Long",
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  final _mockComments = [
    DiscussionComment(
      id: "c1",
      discussionId: "1",
      authorName: "Lan",
      avatarUrl: "https://i.pravatar.cc/40?img=2",
      content: "Mình nghĩ nộp muộn bị trừ 10% điểm.",
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      votes: 1,
    ),
    DiscussionComment(
      id: "c2",
      discussionId: "1",
      authorName: "Bạn",
      avatarUrl: "https://i.pravatar.cc/40?img=3",
      content: "Cảm ơn bạn nhé!",
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      votes: 0,
    ),
  ];

  Future<List<Discussion>> fetchDiscussionsByExercise(int exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDiscussions.where((d) => d.exerciseId == exerciseId).toList();
  }

  Future<List<DiscussionComment>> fetchComments(String discussionId) async {
    await Future.delayed(const Duration(milliseconds: 180));
    return _mockComments.where((c) => c.discussionId == discussionId).toList();
  }

  Future<void> postComment(String discussionId, String content) async {
    await Future.delayed(const Duration(milliseconds: 120));
  }
}
