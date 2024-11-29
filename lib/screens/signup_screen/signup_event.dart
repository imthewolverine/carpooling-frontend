import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupUsernameChanged extends SignupEvent {
  final String username;

  const SignupUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignupPasswordAgainChanged extends SignupEvent {
  final String confirmPassword;

  const SignupPasswordAgainChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class SignupFirstNameChanged extends SignupEvent {
  final String firstName;

  const SignupFirstNameChanged(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class SignupLastNameChanged extends SignupEvent {
  final String lastName;

  const SignupLastNameChanged(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class SignupPhoneNumberChanged extends SignupEvent {
  final String phoneNumber;

  const SignupPhoneNumberChanged(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class SignupSubmitted extends SignupEvent {
  final String role;

  const SignupSubmitted({required this.role});

  @override
  List<Object> get props => [role];
}

class SignupRoleChanged extends SignupEvent {
  final String role;

  const SignupRoleChanged(this.role);

  @override
  List<Object> get props => [role];
}

class TogglePasswordVisibility extends SignupEvent {
  const TogglePasswordVisibility();
}

class ToggleConfirmPasswordVisibility extends SignupEvent {
  const ToggleConfirmPasswordVisibility();
}
