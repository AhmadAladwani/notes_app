import 'package:firebase_auth/firebase_auth.dart';
import 'package:revise_notes/auth/models/auth_user.dart';

class FirebaseAuthProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<AuthUser?> get currentAuthUser async {
    final user = firebaseAuth.currentUser;
    print('getting user');
    if (user != null) {
      return AuthUser.fromDatabase(user);
    } else {
      print('return null');
      return null;
    }
  }

  Future<AuthUser> logInDatabase(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      final authUser = AuthUser.fromDatabase(user);
      return authUser;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<AuthUser> signUpDatabase(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      final authUser = AuthUser.fromDatabase(user);
      return authUser;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> logOutDatabase() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
