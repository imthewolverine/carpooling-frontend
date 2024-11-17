// lib/services/fcm_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class FCMService {
  Future<void> sendTokenToBackend(String? token) async {
    if (token == null) {
      print("FCM token is null, skipping send to backend.");
      return;
    }

    final url = Uri.parse("https://your-backend-url.com/api/save-fcm-token"); // Replace with your backend endpoint
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Add any authorization headers if needed
      },
      body: jsonEncode({
        'token': token,
        'userId': '12345', // Optionally add the user's ID if you need to associate the token with a user
      }),
    );

    if (response.statusCode == 200) {
      print("Token sent to backend successfully.");
    } else {
      print("Failed to send token to backend. Status: ${response.statusCode}");
    }
  }
}
