import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../models/auth_user.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/status_code.dart'; // Import StatusCode

class AuthService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthService() : _storage = const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
      validateStatus: (status) => status != null && status < 500,
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST BODY: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('ERROR[${error.response?.statusCode}] => ${error.message}');
        print('ERROR DATA: ${error.response?.data}');
        return handler.next(error);
      },
    ));
  }

  // Request password reset
  Future<ApiResponse<void>> requestPasswordReset(String username) async {
    try {
      print('=== Starting Password Reset Request ===');
      print('Username: $username');
      print('Base URL: ${_dio.options.baseUrl}');
      print('Connect Timeout: ${_dio.options.connectTimeout}');
      print('Receive Timeout: ${_dio.options.receiveTimeout}');
      
      final response = await _dio.post(
        '/api/auth/forgot-password', 
        data: {'username': username},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );
      
      print('Password reset response: ${response.data}');
      
      // The ApiResponse.fromJson factory now handles determining the StatusCode.
      // The manual check for 404 and specific string status is no longer needed here
      // as fromJson will use StatusCode.fromCode.
      // if (response.statusCode == 404) {
      //   return ApiResponse(
      //     status: StatusCode.USER_NOT_FOUND, // Use StatusCode enum
      //     message: 'User not found',
      //     data: null,
      //   );
      // }

      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      print('=== DioException Details ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      print('Request URL: ${e.requestOptions.uri}');

      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse(
          status: StatusCode.INTERNAL_SERVER_ERROR, // Or a more specific connection error code if available
          message: 'Could not connect to server at ${_dio.options.baseUrl}. Please check if the server is running and accessible.',
          data: null,
        );
      }

      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        return ApiResponse.fromJson(e.response!.data, null);
      }

      return ApiResponse(
        status: StatusCode.INTERNAL_SERVER_ERROR, // Default error status
        message: e.message ?? 'Network error occurred',
        data: null,
      );
    } catch (e) {
      print('Unexpected error: $e');
      return ApiResponse(
        status: StatusCode.INTERNAL_SERVER_ERROR, // Default error status
        message: 'An unexpected error occurred',
        data: null,
      );
    }
  }

  // Reset password with OTP
  Future<ApiResponse<void>> resetPassword(String username, String newPassword) async {
    try {
      print('Resetting password for username: $username');
      final response = await _dio.post('/api/auth/reset-password', data: {
        'username': username,
        'newPassword': newPassword,
      });
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('No token found');

      final response = await _dio.post(
        '/api/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      await _clearStoredCredentials();
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get stored auth user
  Future<AuthUser?> getStoredUser() async {
    final token = await _storage.read(key: 'token');
    final username = await _storage.read(key: 'username');
    final role = await _storage.read(key: 'role');

    if (token != null && username != null && role != null) {
      return AuthUser(
        token: token,
        username: username,
        role: role,
      );
    }
    return null;
  }

  // Clear stored credentials
  Future<void> _clearStoredCredentials() async {
    await _storage.deleteAll();
  }

  // Handle Dio errors
  ApiResponse<T> _handleError<T>(DioException e) {
    print('DioError type: ${e.type}');
    print('DioError message: ${e.message}');
    print('DioError response: ${e.response?.data}');

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiResponse(
        status: StatusCode.INTERNAL_SERVER_ERROR, // Or a more specific connection error code
        message: 'Could not connect to server. Please check your internet connection and try again.',
        data: null,
      );
    }

    if (e.response?.data != null && e.response?.data is Map) {
      try {
        return ApiResponse.fromJson(e.response!.data, null);
      } catch (_) {
        // If parsing fails, fall through to default error
      }
    }

    String errorMessage = switch (e.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out',
      DioExceptionType.sendTimeout => 'Request timed out while sending data',
      DioExceptionType.receiveTimeout => 'Request timed out while waiting for response',
      DioExceptionType.badResponse => 'Server returned an error: ${e.response?.statusCode}',
      DioExceptionType.unknown => e.message ?? 'An unknown error occurred',
      _ => 'Network error occurred'
    };

    return ApiResponse(
      status: StatusCode.INTERNAL_SERVER_ERROR, // Default error status
      message: errorMessage,
      data: null,
    );
  }

  // Verify OTP
  Future<ApiResponse<void>> verifyOTP(String username, String otp) async {
    try {
      print('Verifying OTP for username: $username');
      final response = await _dio.post('/api/auth/verify-otp', data: {
        'username': username,
        'otp': otp,
      });
      // ApiResponse.fromJson will correctly parse the status code from the response data
      return ApiResponse.fromJson(response.data, null);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }
}
