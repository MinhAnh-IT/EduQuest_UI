class DiscussionComment {
  final int id;
  final int discussionId;
  final String content;
  final int voteCount;
  final String createdByName;
  final String? createdByAvatar;
  final int createdBy;
  final DateTime createdAt;

  DiscussionComment({
    required this.id,
    required this.discussionId,
    required this.content,
    required this.voteCount,
    required this.createdByName,
    this.createdByAvatar,
    required this.createdBy,
    required this.createdAt,
  });

  factory DiscussionComment.fromJson(Map<String, dynamic> json) =>
      DiscussionComment(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
        discussionId: json['discussionId'] is int
            ? json['discussionId']
            : int.tryParse(json['discussionId'].toString()) ?? 0,
        content: json['content'] ?? '',
        voteCount: json['voteCount'] ?? 0,
        createdBy: json['createdBy'] is int
            ? json['createdBy']
            : int.tryParse(json['createdBy'].toString()) ?? 0,
        createdByName: json['createdByName'] ?? '',
        createdByAvatar: json['createdByAvatar'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  DiscussionComment copyWith({
    int? id,
    int? discussionId,
    String? content,
    int? voteCount,
    String? createdByName,
    String? createdByAvatar,
    int? createdBy,
    DateTime? createdAt,
  }) {
    return DiscussionComment(
      id: id ?? this.id,
      discussionId: discussionId ?? this.discussionId,
      content: content ?? this.content,
      voteCount: voteCount ?? this.voteCount,
      createdByName: createdByName ?? this.createdByName,
      createdByAvatar: createdByAvatar ?? this.createdByAvatar,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
