import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

class TokenManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getValidAccessToken() async {
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) {
      return await _refreshAccessToken();
    }

    final secondsLeft = _secondsUntilExpire(accessToken);
    if (secondsLeft == null || secondsLeft < 120) {
      return await _refreshAccessToken();
    }
    return accessToken;
  }

  int? _secondsUntilExpire(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp - currentTime;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) {
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['data']['accessToken'];
        final newRefreshToken = data['data']['refreshToken'];
        await _storage.write(key: 'access_token', value: newAccessToken);
        if (newRefreshToken != null) {
          await _storage.write(key: 'refresh_token', value: newRefreshToken);
        }
        return newAccessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
