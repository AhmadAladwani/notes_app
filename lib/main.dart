import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_event.dart';
import 'package:revise_notes/auth/bloc/auth_state.dart';
import 'package:revise_notes/auth/firebase_auth_provider.dart';
import 'package:revise_notes/auth/views/auth_view.dart';
import 'package:revise_notes/bloc/notes_bloc.dart';
import 'package:revise_notes/bloc/notes_event.dart';
import 'package:revise_notes/notes_respository.dart';
import 'package:revise_notes/views/add_update_note_view.dart';
import 'package:revise_notes/views/notes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notesRepository = NotesRepository();
    final firebaseAuthProvider = FirebaseAuthProvider();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(firebaseAuthProvider: firebaseAuthProvider)
                ..add(const AuthEventInitialize()),
        ),
        BlocProvider(
          create: (context) => NotesBloc(notesRepository: notesRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Notes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateLoading) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Loading'),
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AuthStateLoggedOut) {
              return const AuthView(loggingIn: true);
            } else if (state is AuthStateSigningUp) {
              return const AuthView(loggingIn: false);
            } else if (state is AuthStateLoggedIn) {
              final userId = state.userId;
              context
                  .read<NotesBloc>()
                  .add(NotesEventLoadNotes(userId: userId));
              return NotesView(userId: userId);
            } else {
              return const Center(
                child: Text('This should not happen'),
              );
            }
          },
        ),
        routes: {
          AddUpdateNoteView.routeName: (context) => const AddUpdateNoteView(),
        },
      ),
    );
  }
}
