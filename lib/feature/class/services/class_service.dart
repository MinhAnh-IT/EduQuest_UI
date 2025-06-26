import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/models/api_response.dart';
import '../../../core/enums/status_code.dart';
import '../models/class_detail.dart';
import '../models/student.dart';

class ClassService {
  final String baseUrl = ApiConfig.baseUrl;  Future<ApiResponse<ClassDetail>> getClassDetail(int classId) async {
    try {
      final url = Uri.parse('$baseUrl/classes/$classId/detail');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        return ApiResponse<ClassDetail>(
          status: StatusCode.internalServerError,
          message: 'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final int statusCode = responseData['code'] as int;
      final String message = responseData['message'] as String;

      if (statusCode == 200) {
        final classDetailData = responseData['data'];
        if (classDetailData == null) {
          return ApiResponse<ClassDetail>(
            status: StatusCode.internalServerError,
            message: 'No class data received from server',
          );
        }
        
        final classDetail = ClassDetail.fromApiResponse(classDetailData as Map<String, dynamic>);
        
        return ApiResponse<ClassDetail>(
          status: StatusCode.ok,
          message: message,
          data: classDetail,
        );
      } else if (statusCode == 407) {
        return ApiResponse<ClassDetail>(
          status: StatusCode.classNotFoundById,
          message: message,
        );
      } else {
        return ApiResponse<ClassDetail>(
          status: StatusCode.internalServerError,
          message: message.isNotEmpty ? message : 'Không thể lấy thông tin chi tiết lớp học',
        );
      }
    } catch (e) {
      return ApiResponse<ClassDetail>(
        status: StatusCode.internalServerError,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
    Future<ApiResponse<List<Student>>> getStudentsInClass(int classId) async {
    try {
      final url = Uri.parse('$baseUrl/classes/$classId/students/enrolled');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        return ApiResponse<List<Student>>(
          status: StatusCode.internalServerError,
          message: 'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final int statusCode = responseData['code'] as int;
      final String message = responseData['message'] as String;

      if (statusCode == 200) {
        final studentsData = responseData['data'];
        if (studentsData == null) {
          // No students found, return empty list
          return ApiResponse<List<Student>>(
            status: StatusCode.ok,
            message: message,
            data: [],
          );
        }
        
        final students = (studentsData as List<dynamic>)
            .map((studentJson) => Student.fromJson(studentJson as Map<String, dynamic>))
            .toList();
        
        return ApiResponse<List<Student>>(
          status: StatusCode.ok,
          message: message,
          data: students,
        );
      } else if (statusCode == 407) {
        return ApiResponse<List<Student>>(
          status: StatusCode.classNotFoundById,
          message: message,
        );
      } else {
        return ApiResponse<List<Student>>(
          status: StatusCode.internalServerError,
          message: message.isNotEmpty ? message : 'Không thể lấy danh sách học sinh',
        );
      }
    } catch (e) {
      return ApiResponse<List<Student>>(
        status: StatusCode.internalServerError,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
