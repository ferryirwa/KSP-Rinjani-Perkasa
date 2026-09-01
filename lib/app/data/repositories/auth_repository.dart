import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
    String? firebaseToken,
  }) async {
    final response = await _apiService.post(
      ApiConstants.login,
      data: {
        'login': login,
        'password': password,
        if (firebaseToken != null && firebaseToken.isNotEmpty)
          'firebase_token': firebaseToken,
      },
      requiresAuth: false,
    );

    final data = response.data;

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const FormatException(
      'Respons login dari server bukan JSON yang valid.',
    );
  }

  Future<void> updateFirebaseToken(String firebaseToken) async {
    await _apiService.post(
      ApiConstants.firebaseToken,
      data: {'firebase_token': firebaseToken},
    );
  }
}
