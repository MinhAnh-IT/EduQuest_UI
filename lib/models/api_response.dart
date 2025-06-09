class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJson) {
    // Handle both 'status' (string) and 'code' (int) for status field
    String statusValue;
    if (json.containsKey('status') && json['status'] is String) {
      statusValue = json['status'] as String;
    } else if (json.containsKey('code')) {
      // If 'code' exists, use its string representation
      statusValue = json['code'].toString();
    } else {
      // Fallback or throw error if neither is present
      statusValue = 'ERROR'; // Or throw an exception
    }

    return ApiResponse(
      status: statusValue,
      message: json['message'] as String? ?? 'An error occurred', // Provide a default message if null
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
}
