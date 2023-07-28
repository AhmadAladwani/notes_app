import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthUser {
  final String id;
  final String email;

  const AuthUser({
    required this.id,
    required this.email,
  });

  factory AuthUser.fromDatabase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
      );
}
