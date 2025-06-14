import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/enrollment.dart';
import '../../auth/models/api_response.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/status_code.dart';

class EnrollmentService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  EnrollmentService() : _storage = const FlutterSecureStorage() {
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

  // Get Authorization token from storage
  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Join Class
  Future<ApiResponse<Enrollment>> joinClass(String classCode) async {
    try {
      print('=== Starting Join Class Request ===');
      print('Class Code: $classCode');
      
      final token = await _getAuthToken();
      if (token == null) {
        return ApiResponse<Enrollment>(
          status: StatusCode.INVALID_TOKEN,
          message: 'Authentication token not found',
        );
      }

      final response = await _dio.post(
        '/api/enrollments/join',
        data: {'classCode': classCode},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('Response received: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return ApiResponse<Enrollment>.fromJson(
          response.data,
          (data) => Enrollment.fromJson(data),
        );
      } else {
        return ApiResponse<Enrollment>.fromJson(response.data, null);
      }
    } on DioException catch (e) {
      print('=== DioException in joinClass ===');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<Enrollment>.fromJson(e.response!.data, null);
      }

      return ApiResponse<Enrollment>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      print('=== General Exception in joinClass ===');
      print('Error: $e');
      return ApiResponse<Enrollment>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Leave Class
  Future<ApiResponse<void>> leaveClass(int classId) async {
    try {
      print('=== Starting Leave Class Request ===');
      print('Class ID: $classId');
      
      final token = await _getAuthToken();
      if (token == null) {
        return ApiResponse<void>(
          status: StatusCode.INVALID_TOKEN,
          message: 'Authentication token not found',
        );
      }

      final response = await _dio.delete(
        '/api/enrollments/leave/$classId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('Response received: ${response.statusCode}');
      print('Response data: ${response.data}');

      return ApiResponse<void>.fromJson(response.data, null);
    } on DioException catch (e) {
      print('=== DioException in leaveClass ===');
      print('Error type: ${e.type}');
      print('Error message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<void>.fromJson(e.response!.data, null);
      }

      return ApiResponse<void>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      print('=== General Exception in leaveClass ===');
      print('Error: $e');
      return ApiResponse<void>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: 'An unexpected error occurred',
      );
    }
  }
}
