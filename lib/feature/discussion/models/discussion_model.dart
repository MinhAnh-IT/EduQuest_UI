class Discussion {
  final int id;
  final String content;
  final int createdById;
  final String createdByName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Discussion({
    required this.id,
    required this.content,
    required this.createdById,
    required this.createdByName,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
        content: json['content'] ?? '',
        createdById: json['createdById'] is int
            ? json['createdById']
            : int.tryParse(json['createdById'].toString()) ?? 0,
        createdByName: json['createdByName'] ?? '',
        avatarUrl: json['avatarUrl'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      );
}
