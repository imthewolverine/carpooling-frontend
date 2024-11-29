import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app/';

  SignupBloc() : super(const SignupState()) {
    on<SignupUsernameChanged>(_onUsernameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupPasswordAgainChanged>(_onPasswordAgainChanged);
    on<SignupFirstNameChanged>(_onFirstNameChanged);
    on<SignupLastNameChanged>(_onLastNameChanged);
    on<SignupPhoneNumberChanged>(_onPhoneNumberChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<SignupRoleChanged>(_onRoleChanged);
  }

  void _onUsernameChanged(
      SignupUsernameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onPasswordAgainChanged(
      SignupPasswordAgainChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onFirstNameChanged(
      SignupFirstNameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _onLastNameChanged(
      SignupLastNameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(lastName: event.lastName));
  }

  void _onPhoneNumberChanged(
      SignupPhoneNumberChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onRoleChanged(SignupRoleChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(role: event.role));
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleConfirmPasswordVisibility(
      ToggleConfirmPasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    // Validate inputs locally
    if (state.username.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.phoneNumber.isEmpty) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'All fields are required',
      ));
      return;
    }

    if (!await _isEmailValid(state.email)) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Invalid email format',
      ));
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Passwords do not match',
      ));
      return;
    }

    // Select API endpoint based on role
    String apiEndpoint;
    if (event.role == "Эцэг эх") {
      apiEndpoint = '$baseUrl/register-user';
    } else if (event.role == "Жолооч") {
      apiEndpoint = '$baseUrl/register-driver';
    } else {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Invalid role',
      ));
      return;
    }
    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    ));
    //try {
    //  final response = await http.post(
    //    Uri.parse(apiEndpoint),
    //    headers: <String, String>{
    //      'Content-Type': 'application/json; charset=UTF-8',
    //    },
    //    body: jsonEncode(<String, dynamic>{
    //      'username': state.username,
    //      'email': state.email,
    //      'password': state.password,
    //      'firstName': state.firstName,
    //      'lastName': state.lastName,
    //      'phoneNumber': state.phoneNumber,
    //    }),
    //  );
//
    //  if (response.statusCode == 200) {
    //    emit(state.copyWith(
    //      isSubmitting: false,
    //      isSuccess: true,
    //      isFailure: false,
    //    ));
    //  } else {
    //    final errorResponse = json.decode(response.body);
    //    emit(state.copyWith(
    //      isSubmitting: false,
    //      isSuccess: false,
    //      isFailure: true,
    //      errorMessage: errorResponse['message'] ?? 'Registration failed',
    //    ));
    //  }
    //} catch (e) {
    //  emit(state.copyWith(
    //    isSubmitting: false,
    //    isSuccess: false,
    //    isFailure: true,
    //    errorMessage: 'Failed to connect to the server',
    //  ));
    //}
  }

  Future<bool> _isEmailValid(String email) async {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
