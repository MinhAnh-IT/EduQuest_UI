import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccessTokenUtil {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  static Future<int?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final decoded = JwtDecoder.decode(token);
      return int.tryParse(decoded['sub'].toString());
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getUsername() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded['username']?.toString();
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getRole() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final decoded = JwtDecoder.decode(token);
      return decoded['role']?.toString();
    } catch (_) {
      return null;
    }
  }
}
