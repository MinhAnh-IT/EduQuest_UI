import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import '../exceptions/auth_exception.dart';

class ApiClient {
  static String? token;

  static Future<Map<String, String>> getHeaders({bool useAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers':
          'Origin, Content-Type, Accept, Authorization, X-Request-With',
    };

    if (useAuth) {
      token = await TokenManager().getValidAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        
      }
    }
    return headers;
  }

  static Future<http.Response> post(String url, dynamic body,
      {bool auth = true}) async {
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: await getHeaders(useAuth: auth), body: jsonEncode(body));

    if (auth && (response.statusCode == 401 || response.statusCode == 403)) {
      token = await TokenManager().getValidAccessToken();
      if (token == null) {
        throw AuthException('Không thể làm mới token. Vui lòng đăng nhập lại.');
      }
      final retryResponse = await http.post(uri,
          headers: await getHeaders(useAuth: auth), body: jsonEncode(body));
      return retryResponse;
    }

    return response;
  }

  static Future<http.Response> get(String url, {bool auth = false}) async {
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: await getHeaders(useAuth: auth));

    if (auth && (response.statusCode == 401 || response.statusCode == 403)) {
      token = await TokenManager().getValidAccessToken();
      if (token == null) {
        throw AuthException('Không thể làm mới token. Vui lòng đăng nhập lại.');
      }
      final retryResponse =
          await http.get(uri, headers: await getHeaders(useAuth: auth));
      return retryResponse;
    }

    return response;
  }

  static Future<http.Response> put(String url, dynamic body,
      {bool auth = false}) async {
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        headers: await getHeaders(useAuth: auth), body: jsonEncode(body));

    if (auth && (response.statusCode == 401 || response.statusCode == 403)) {
      token = await TokenManager().getValidAccessToken();
      if (token == null) {
        throw AuthException('Không thể làm mới token. Vui lòng đăng nhập lại.');
      }
      final retryResponse = await http.put(uri,
          headers: await getHeaders(useAuth: auth), body: jsonEncode(body));
      return retryResponse;
    }

    return response;
  }

  static Future<http.Response> delete(String url, {bool auth = false}) async {
    final uri = Uri.parse(url);
    final response =
        await http.delete(uri, headers: await getHeaders(useAuth: auth));

    if (auth && (response.statusCode == 401 || response.statusCode == 403)) {
      token = await TokenManager().getValidAccessToken();
      if (token == null) {
        throw AuthException('Không thể làm mới token. Vui lòng đăng nhập lại.');
      }
      final retryResponse =
          await http.delete(uri, headers: await getHeaders(useAuth: auth));
      return retryResponse;
    }

    return response;
  }
}
