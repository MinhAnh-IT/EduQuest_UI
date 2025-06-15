import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enrollment.dart';
import '../../auth/models/api_response.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/status_code.dart';
import '../../../shared/utils/constants.dart';

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
  }  // Get Authorization token from storage
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageConstants.token);
  }
  // Join Class
  Future<ApiResponse<Enrollment>> joinClass(String classCode) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        return ApiResponse<Enrollment>(
          status: StatusCode.INVALID_TOKEN,
          message: 'Authentication token not found',
        );
      }

      final response = await _dio.post(
        ApiConfig.joinClass,
        data: {'classCode': classCode},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse<Enrollment>.fromJson(
          response.data,
          (data) => Enrollment.fromJson(data),
        );
      } else {
        return ApiResponse<Enrollment>.fromJson(response.data, null);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<Enrollment>.fromJson(e.response!.data, null);
      }

      return ApiResponse<Enrollment>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse<Enrollment>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: 'An unexpected error occurred',
      );
    }
  }
  
  // Leave Class
  Future<ApiResponse<void>> leaveClass(int classId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        return ApiResponse<void>(
          status: StatusCode.INVALID_TOKEN,
          message: 'Authentication token not found',
        );
      }

      final response = await _dio.delete(
        '${ApiConfig.leaveClass}/$classId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return ApiResponse<void>.fromJson(response.data, null);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return ApiResponse<void>.fromJson(e.response!.data, null);
      }

      return ApiResponse<void>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: e.message ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse<void>(
        status: StatusCode.INTERNAL_SERVER_ERROR,
        message: 'An unexpected error occurred',
      );
    }
  }
}
