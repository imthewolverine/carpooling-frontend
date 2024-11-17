import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'ad_description_event.dart';
import 'ad_description_state.dart';
import '../../services/secure_storage_service.dart';

class AdDescriptionBloc extends Bloc<AdDescriptionEvent, AdDescriptionState> {
  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app/';
  final SecureStorageService _secureStorage = SecureStorageService();

  AdDescriptionBloc() : super(AdDescriptionInitial()) {
    on<SubmitJobRequest>(_onSubmitJobRequest);
  }

  Future<void> _onSubmitJobRequest(
      SubmitJobRequest event, Emitter<AdDescriptionState> emit) async {
    emit(JobRequestLoading());

    try {
      // Retrieve the stored token
      final token = await _secureStorage.getToken();

      if (token == null) {
        emit(JobRequestError("Authentication token not found"));
        return;
      }

      // Decode the token to get the user ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken[
          'user_id']; // Adjust key as per backend's user ID field in JWT

      if (userId == null) {
        emit(JobRequestError("User ID not found in token"));
        return;
      }

      // Prepare the request body
      final requestBody = {
        "Status": "pending",
        "WorkerID": userId,
      };

      // Send the API request with the token in the Authorization header
      final response = await http.post(
        Uri.parse('$baseUrl/ads/${event.adId}/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        emit(JobRequestSuccess());
      } else {
        emit(JobRequestError("Failed to send job request: ${response.body}"));
      }
    } catch (e) {
      emit(JobRequestError("Failed to send job request"));
    }
  }
}
