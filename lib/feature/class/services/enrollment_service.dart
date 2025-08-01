import 'dart:convert';
import '../models/enrollment.dart';
import '../../auth/models/api_response.dart';
import '../../../config/api_config.dart';
import '../../../core/enums/status_code.dart';
import '../../../core/enums/convert_status.dart';
import '../../../core/network/api_client.dart';
import '../../../core/exceptions/auth_exception.dart';

class EnrollmentService {
  Future<ApiResponse<Enrollment>> joinClass(String classCode) async {
    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.joinClass}';
      final response = await ApiClient.post(
        url,
        {'classCode': classCode.trim()},
        auth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          return ApiResponse<Enrollment>(
            status: StatusCode.fromCode(responseData['code']) ?? StatusCode.ok,
            message: responseData['message'] ?? 'Thành công',
            data: Enrollment.fromJson(responseData['data']),
          );
        } else {
          return ApiResponse<Enrollment>(
            status: StatusCode.fromCode(responseData['code']) ?? StatusCode.ok,
            message: responseData['message'] ?? 'Thành công',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        final rawMessage = responseData['message'] ?? 'Đã xảy ra lỗi';
        final translatedMessage = ConvertStatus.translateErrorMessage(rawMessage);
        return ApiResponse<Enrollment>(
          status: StatusCode.fromCode(responseData['code']) ?? StatusCode.internalServerError,
          message: translatedMessage,
        );
      }
    } catch (e) {
      return ApiResponse<Enrollment>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<ApiResponse<void>> leaveClass(int classId) async {
    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.leaveClass}/$classId';
      final response = await ApiClient.delete(url, auth: true);

      final responseData = json.decode(response.body);
      final rawMessage = responseData['message'] ?? 'Thành công';
      final translatedMessage = ConvertStatus.translateErrorMessage(rawMessage);
      return ApiResponse<void>(
        status: StatusCode.fromCode(responseData['code']) ?? StatusCode.ok,
        message: translatedMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<ApiResponse<List<Enrollment>>> getMyClasses() async {
    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.myClasses}';
      final response = await ApiClient.get(url, auth: true);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] as List<dynamic>;
        final enrollments = data.map((json) => Enrollment.fromJson(json)).toList();
        
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.ok,
          message: responseData['message'] ?? 'Thành công',
          data: enrollments,
        );
      } else {
        final responseData = json.decode(response.body);
        final rawMessage = responseData['message'] ?? 'Đã xảy ra lỗi';
        final translatedMessage = ConvertStatus.translateErrorMessage(rawMessage);
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(responseData['code']) ?? StatusCode.internalServerError,
          message: translatedMessage,
        );
      }
    } on AuthException {
      return ApiResponse<List<Enrollment>>(
        status: StatusCode.badRequest,
        message: 'Yêu cầu đăng nhập',
      );
    } catch (e) {
      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<ApiResponse<List<Enrollment>>> getMyEnrolledClasses() async {
    try {
      final url = '${ApiConfig.baseUrl}${ApiConfig.myEnrolledClasses}';
      final response = await ApiClient.get(url, auth: true);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] as List<dynamic>;
        final enrollments = data.map((json) => Enrollment.fromJson(json)).toList();
        
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.ok,
          message: responseData['message'] ?? 'Thành công',
          data: enrollments,
        );
      } else {
        final responseData = json.decode(response.body);
        final rawMessage = responseData['message'] ?? 'Đã xảy ra lỗi';
        final translatedMessage = ConvertStatus.translateErrorMessage(rawMessage);
        return ApiResponse<List<Enrollment>>(
          status: StatusCode.fromCode(responseData['code']) ?? StatusCode.internalServerError,
          message: translatedMessage,
        );
      }
    } catch (e) {
      return ApiResponse<List<Enrollment>>(
        status: StatusCode.internalServerError,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }
}
