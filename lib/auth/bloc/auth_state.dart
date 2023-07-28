import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

@immutable
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

@immutable
class AuthStateLoggedIn extends AuthState {
  final String userId;
  const AuthStateLoggedIn({required this.userId});
}

@immutable
class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

@immutable
class AuthStateSigningUp extends AuthState {
  const AuthStateSigningUp();
}
