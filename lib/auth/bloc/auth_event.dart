import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

@immutable
class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

@immutable
class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;
  const AuthEventSignUp({
    required this.email,
    required this.password,
  });
}

@immutable
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

@immutable
class AuthEventSigningUp extends AuthEvent {
  const AuthEventSigningUp();
}

@immutable
class AuthEventLoggingIn extends AuthEvent {
  const AuthEventLoggingIn();
}
