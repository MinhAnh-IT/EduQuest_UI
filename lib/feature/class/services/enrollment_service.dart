import 'package:dio/dio.dart';
import '../models/enrollment.dart';
import '../../auth/models/api_response.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/status_code.dart';
import '../../../core/network/api_client.dart';

class EnrollmentService {
  late final Dio _dio;
  
  EnrollmentService() {
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
        // Tự động thêm Authorization header từ ApiClient.token
        final token = ApiClient.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Join Class
  Future<ApiResponse<Enrollment>> joinClass(String classCode) async {
    try {
      final response = await _dio.post(
        ApiConfig.joinClass,
        data: {'classCode': classCode.trim()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['data'] != null) {
          return ApiResponse<Enrollment>.fromJson(
            response.data,
            (data) => Enrollment.fromJson(data),
          );
        } else {
          // API trả về success nhưng không có data (thường là trường hợp PENDING)
          return ApiResponse<Enrollment>(
            status: StatusCode.fromCode(response.data['code']) ?? StatusCode.ok,
            message: response.data['message'] ?? 'Thành công',
          );
        }
      } else {
        return ApiResponse<Enrollment>.fromJson(response.data, null);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<Enrollment>.fromJson(e.response!.data, null);
      }

      return ApiResponse<Enrollment>(
        status: StatusCode.internalServerError,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse<Enrollment>(
        status: StatusCode.internalServerError,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Leave Class
  Future<ApiResponse<void>> leaveClass(int classId) async {
    try {
      final response = await _dio.delete('${ApiConfig.leaveClass}/$classId');

      return ApiResponse<void>.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<void>.fromJson(e.response!.data, null);
      }

      return ApiResponse<void>(
        status: StatusCode.internalServerError,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse<void>(
        status: StatusCode.internalServerError,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Get student's enrolled classes
  Future<ApiResponse<List<Enrollment>>> getMyClasses() async {
    try {
      final response = await _dio.get(ApiConfig.myClasses);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final enrollments = data.map((json) => Enrollment.fromJson(json)).toList();
        
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.ok,
          message: response.data['message'] ?? 'Thành công',
          data: enrollments,
        );
      } else {
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(response.data['code']) ?? StatusCode.internalServerError,
          message: response.data['message'] ?? 'Đã xảy ra lỗi',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(e.response!.data['code']) ?? StatusCode.internalServerError,
          message: e.response!.data['message'] ?? 'Lỗi kết nối',
        );
      }

      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: e.message ?? 'Lỗi kết nối mạng',
      );
    } catch (e) {
      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn: $e',
      );
    }
  }

  // Get My Enrolled Classes (ENROLLED status only)
  Future<ApiResponse<List<Enrollment>>> getMyEnrolledClasses() async {
    try {
      final response = await _dio.get(ApiConfig.myEnrolledClasses);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final enrollments = data.map((json) => Enrollment.fromJson(json)).toList();
        
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.ok,
          message: response.data['message'] ?? 'Thành công',
          data: enrollments,
        );
      } else {
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(response.data['code']) ?? StatusCode.internalServerError,
          message: response.data['message'] ?? 'Đã xảy ra lỗi',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(e.response!.data['code']) ?? StatusCode.internalServerError,
          message: e.response!.data['message'] ?? 'Lỗi kết nối',
        );
      }

      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: e.message ?? 'Lỗi kết nối mạng',
      );
    } catch (e) {
      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn: $e',
      );
    }
  }
}
