import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:register_login/config/api_config.dart';
import 'package:register_login/models/user_model.dart';
import 'package:register_login/models/student_model.dart';

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;
  String? _token;

  // Setter for token
  set token(String? value) {
    _token = value;
  }

  // Auth APIs
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConfig.login}'),
      headers: ApiConfig.getHeaders(null),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đăng nhập thất bại: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConfig.register}'),
      headers: ApiConfig.getHeaders(null),
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đăng ký thất bại: ${response.body}');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConfig.verifyOtp}'),
      headers: ApiConfig.getHeaders(null),
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Xác thực OTP thất bại: ${response.body}');
    }
  }

  Future<bool> resendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConfig.resendOtp}'),
      headers: ApiConfig.getHeaders(null),
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gửi lại OTP thất bại: ${response.body}');
    }
  }

  // Student APIs
  Future<Student> saveStudentDetails(Map<String, dynamic> studentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiConfig.studentDetails}'),
      headers: ApiConfig.getHeaders(_token),
      body: jsonEncode(studentData),
    );

    if (response.statusCode == 201) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lưu thông tin sinh viên: ${response.body}');
    }
  }

  Future<Student> getStudentDetails(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiConfig.studentDetails}/$userId'),
      headers: ApiConfig.getHeaders(_token),
    );

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể lấy thông tin sinh viên: ${response.body}');
    }
  }

  Future<Student> updateStudentDetails(int userId, Map<String, dynamic> studentData) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiConfig.updateStudent}/$userId'),
      headers: ApiConfig.getHeaders(_token),
      body: jsonEncode(studentData),
    );

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể cập nhật thông tin sinh viên: ${response.body}');
    }
  }
} 