class SubmitedModel {
  final int participationId;
  final String status;
  DateTime submittedAt;

  SubmitedModel({
    required this.participationId,
    required this.status,
    required this.submittedAt
  });

  factory SubmitedModel.fromJson(Map<String, dynamic> json){
    return 
      SubmitedModel(
        participationId: json['participationId'], 
        status: json['status'], 
        submittedAt: DateTime.parse(json['submittedAt'])
      );
  }
}