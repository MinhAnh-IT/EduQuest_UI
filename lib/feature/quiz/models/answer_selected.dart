class AnswerSelected {
  final int exerciseQuestionId;
  final int selectedAnswerId;

  AnswerSelected(
      {required this.exerciseQuestionId, required this.selectedAnswerId});

  Map<String, dynamic> toJson() {
    return {
      'exerciseQuestionId': exerciseQuestionId,
      'selectedAnswerId': selectedAnswerId
    };
  }
}
