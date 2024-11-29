import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role; // Added role field
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final bool obscurePassword; // To toggle password visibility
  final bool obscureConfirmPassword; // To toggle confirm password visibility

  const SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.role = '', // Default to an empty string
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorMessage = '',
    this.obscurePassword = true, // Initially hide password
    this.obscureConfirmPassword = true, // Initially hide confirm password
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? role,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        confirmPassword,
        firstName,
        lastName,
        phoneNumber,
        role,
        isSubmitting,
        isSuccess,
        isFailure,
        errorMessage,
        obscurePassword,
        obscureConfirmPassword,
      ];
}
