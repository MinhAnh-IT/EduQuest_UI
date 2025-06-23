class Discussion {
  final String id;
  final int exerciseId;
  final String title;
  final String authorName;
  final DateTime createdAt;

  Discussion({
    required this.id,
    required this.exerciseId,
    required this.title,
    required this.authorName,
    required this.createdAt,
  });
}

class DiscussionComment {
  final String id;
  final String discussionId;
  final String authorName;
  final String avatarUrl;
  final String content;
  final DateTime createdAt;
  final int votes;

  DiscussionComment({
    required this.id,
    required this.discussionId,
    required this.authorName,
    required this.avatarUrl,
    required this.content,
    required this.createdAt,
    required this.votes,
  });
}
