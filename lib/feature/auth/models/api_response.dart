import '../../../core/enums/status_code.dart'; 

class ApiResponse<T> {
  final StatusCode status; 
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJson) {
    int statusCodeValue = 500; 
    if (json.containsKey('code') && json['code'] is int) {
      statusCodeValue = json['code'] as int;
    } else if (json.containsKey('status') && json['status'] is int) { 
      statusCodeValue = json['status'] as int;
    } else if (json.containsKey('status') && json['status'] is String) {        try {
            statusCodeValue = int.parse(json['status'] as String);
        } catch (e) {
            // Error parsing status string to int: ${json['status']}
        }
    }

    String messageValue = json['message'] as String? ?? 'An error occurred';    
    return ApiResponse(
      status: StatusCode.fromCode(statusCodeValue) ?? StatusCode.internalServerError, // Handle null case
      message: messageValue,
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
}
