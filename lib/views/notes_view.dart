import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_event.dart';
import 'package:revise_notes/bloc/notes_bloc.dart';
import 'package:revise_notes/bloc/notes_event.dart';
import 'package:revise_notes/bloc/notes_state.dart';
import 'package:revise_notes/views/add_update_note_view.dart';

class NotesView extends StatelessWidget {
  final String userId;
  const NotesView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthEventLogOut()),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              AddUpdateNoteView.routeName,
              arguments: {
                'note': null,
                'userId': userId,
              },
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NotesStateLoaded) {
            final notes = state.notes;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  leading: Text(note.id.toString()),
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: IconButton(
                    onPressed: () => context.read<NotesBloc>().add(
                          NotesEventDelete(
                            userId: userId,
                            noteId: note.id,
                          ),
                        ),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    AddUpdateNoteView.routeName,
                    arguments: {
                      'note': note,
                      'userId': userId,
                    },
                  ),
                );
              },
            );
          } else {
            return const Text('This should not happen.');
          }
        },
      ),
    );
  }
}
