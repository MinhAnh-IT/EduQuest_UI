import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static String? token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzIiwiYXVkIjoiRWR1UXVlc3RBdWRpZW5jZSIsImlhdCI6MTc1MDIxODYwOCwidXNlcm5hbWUiOiJzdHVkZW50MSIsImlzcyI6IkVkdVF1ZXN0SXNzdWVyIiwiZXhwIjoxNzUwMjIyMjA4LCJyb2xlIjoiUk9MRV9TVFVERU5UIn0.VivkXsPefhbiOx5sfjAa6D_UfIJYtA4iSvWdQ4e9_Rg";
  static Map<String, String> _getHeaders({bool useAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (useAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> post(String url, dynamic body, {bool auth = true}) async {
    final uri = Uri.parse(url);
    return await http.post(uri, headers: _getHeaders(useAuth: auth), body: jsonEncode(body));
  }

  static Future<http.Response> get(String url, {bool auth = false}) async {
    final uri = Uri.parse(url);
    return await http.get(uri, headers: _getHeaders(useAuth: auth));
  }

  static Future<http.Response> put(String url, dynamic body, {bool auth = false}) async {
    final uri = Uri.parse(url);
    return await http.put(uri, headers: _getHeaders(useAuth: auth), body: jsonEncode(body));
  }

  static Future<http.Response> delete(String url, {bool auth = false}) async {
    final uri = Uri.parse(url);
    return await http.delete(uri, headers: _getHeaders(useAuth: auth));
  }
}
