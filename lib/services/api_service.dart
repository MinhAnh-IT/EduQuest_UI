import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:register_login/config/api_config.dart';
import 'package:register_login/models/user_model.dart';
import 'package:register_login/models/student_model.dart';
import 'package:register_login/utils/constants.dart';

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;
  String? _token;

  // Setter for token
  set token(String? value) {
    _token = value;
  }

  // Auth APIs
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.login}'),
        headers: ApiConfig.getHeaders(null),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.successCode) {
        return jsonDecode(response.body);
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.register}'),
        headers: ApiConfig.getHeaders(null),
        body: jsonEncode(userData),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.createdCode) {
        return jsonDecode(response.body);
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.verifyOtp}'),
        headers: ApiConfig.getHeaders(null),
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.successCode) {
        return true;
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  Future<bool> resendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.resendOtp}'),
        headers: ApiConfig.getHeaders(null),
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.successCode) {
        return true;
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  // Student APIs
  Future<Student> saveStudentDetails(Map<String, dynamic> studentData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.studentDetails}'),
        headers: ApiConfig.getHeaders(_token),
        body: jsonEncode(studentData),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.createdCode) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  Future<Student> getStudentDetails(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.studentDetails}/$userId'),
        headers: ApiConfig.getHeaders(_token),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.successCode) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }

  Future<Student> updateStudentDetails(int userId, Map<String, dynamic> studentData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl${ApiConfig.updateStudent}/$userId'),
        headers: ApiConfig.getHeaders(_token),
        body: jsonEncode(studentData),
      ).timeout(AppConstants.apiTimeout);

      if (response.statusCode == ApiConfig.successCode) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(ApiConfig.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      throw Exception(AppConstants.networkError);
    }
  }
}