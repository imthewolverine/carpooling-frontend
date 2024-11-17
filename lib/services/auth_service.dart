import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carpooling_frontend/models/user_model.dart';
import 'package:carpooling_frontend/services/secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();

  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app/';

  Future<String?> authenticateUser(
      String usernameOrEmail, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usernameOrEmail': usernameOrEmail, // Updated key to match API format
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Assuming the API returns a `token` and `user` object in the response
        final token = responseBody['token'];

        // Save token and user in secure storage
        await _secureStorage.saveToken(token);

        return token;
      } else {
        return null; // Authentication failed
      }
    } catch (e) {
      print('Error during authentication: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null;
  }

  Future<User?> getUser() async {
    return await _secureStorage.getUser();
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    await _secureStorage.deleteUser();
  }
}
