import 'package:bloc/bloc.dart';
import 'package:revise_notes/auth/bloc/auth_event.dart';
import 'package:revise_notes/auth/bloc/auth_state.dart';
import 'package:revise_notes/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthProvider firebaseAuthProvider;
  AuthBloc({required this.firebaseAuthProvider})
      : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        final authUser = await firebaseAuthProvider.currentAuthUser;
        if (authUser != null) {
          final userId = authUser.id;
          emit(AuthStateLoggedIn(userId: userId));
        } else {
          print('state is logged out');
          emit(const AuthStateLoggedOut());
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoading());
        final email = event.email;
        final password = event.password;
        try {
          final authUser =
              await firebaseAuthProvider.logInDatabase(email, password);
          final userId = authUser.id;
          emit(AuthStateLoggedIn(userId: userId));
        } catch (e) {
          print(e);
          emit(const AuthStateLoggedOut());
        }
      },
    );
    on<AuthEventSignUp>(
      (event, emit) async {
        emit(const AuthStateLoading());
        final email = event.email;
        final password = event.password;
        try {
          final authUser =
              await firebaseAuthProvider.signUpDatabase(email, password);
          final userId = authUser.id;
          emit(AuthStateLoggedIn(userId: userId));
        } catch (e) {
          print(e);
          emit(const AuthStateSigningUp());
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateLoading());
        try {
          await firebaseAuthProvider.logOutDatabase();
          emit(const AuthStateLoggedOut());
        } catch (e) {
          print(e);
        }
      },
    );
    on<AuthEventSigningUp>((event, emit) => emit(const AuthStateSigningUp()));
    on<AuthEventLoggingIn>((event, emit) => emit(const AuthStateLoggedOut()));
  }
}
