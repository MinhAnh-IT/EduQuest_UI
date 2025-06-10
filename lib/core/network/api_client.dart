import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static String? token;

  static Map<String, String> _getHeaders({bool useAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (useAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> post(String url, dynamic body, {bool auth = false}) async {
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
