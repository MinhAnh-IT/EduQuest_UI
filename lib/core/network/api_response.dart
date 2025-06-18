class ApiResponse<T> {
  final int code;
  final String message;
  final T data;

  ApiResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromDataJson,
  ) {
    int codeValue = -1;
    if (json['code'] is int) {
      codeValue = json['code'];
    } else if (json['code'] != null) {
      codeValue = int.tryParse(json['code'].toString()) ?? -1;
    }

    return ApiResponse(
      code: codeValue,
      message: json['message'] ?? '',
      data: fromDataJson(json['data']),
    );
  }
}
