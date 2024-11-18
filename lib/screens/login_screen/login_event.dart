part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class Check extends LoginEvent {
  final String username;
  final String password;
  final String accountType; // user or driver

  const   Check({
    required this.username,
    required this.password,
    required this.accountType,
  });

  @override
  List<Object> get props => [username, password, accountType];
}

// Event to toggle password visibility
class TogglePasswordVisibility extends LoginEvent {
  final bool obscurePassword;

  const TogglePasswordVisibility({required this.obscurePassword});

  @override
  List<Object> get props => [obscurePassword];
}
