class AnswerModel {
  final int id;
  final String content;

  AnswerModel({
    required this.id,
    required this.content,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      content: json['content'],
    );
  }
}
