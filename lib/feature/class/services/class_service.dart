import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/models/api_response.dart';
import '../../../core/enums/status_code.dart';
import '../models/class_detail.dart';
import '../models/student.dart';

class ClassService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<ApiResponse<ClassDetail>> getClassDetail(int classId) async {
    try {
      final url = Uri.parse('$baseUrl/classes/$classId/detail');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      final int statusCode = responseData['code'] as int;
      final String message = responseData['message'] as String;

      if (statusCode == 200) {
        final classDetailData = responseData['data'] as Map<String, dynamic>;
        final classDetail = ClassDetail.fromApiResponse(classDetailData);
        
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
          message: message.isNotEmpty ? message : 'Failed to retrieve class detail',
        );
      }
    } catch (e) {
      return ApiResponse<ClassDetail>(
        status: StatusCode.internalServerError,
        message: 'Network error: ${e.toString()}',      );
    }
  }

  Future<ApiResponse<List<Student>>> getStudentsInClass(int classId) async {
    try {
      final url = Uri.parse('$baseUrl/classes/$classId/students');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      final int statusCode = responseData['code'] as int;
      final String message = responseData['message'] as String;

      if (statusCode == 200) {
        final studentsData = responseData['data'] as List<dynamic>;
        final students = studentsData
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
          message: message.isNotEmpty ? message : 'Failed to retrieve students list',
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
