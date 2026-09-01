import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = 'auth_token';

  static SharedPreferences? _prefs;
  static String? _cachedToken;

  static Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(tokenKey, token);
    _cachedToken = token;
  }

  static Future<String?> getToken() async {
    final cachedToken = _cachedToken;

    if (cachedToken != null) {
      return cachedToken;
    }

    final prefs = await _preferences;
    _cachedToken = prefs.getString(tokenKey);
    return _cachedToken;
  }

  static Future<void> clearToken() async {
    final prefs = await _preferences;
    await prefs.remove(tokenKey);
    _cachedToken = null;
  }
}
