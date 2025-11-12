import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> props() => [];
}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> props() => [email, password];
}

class LoginWithGoogleEvent extends AuthEvent {
  const LoginWithGoogleEvent();
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> props() => [name, email, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}
