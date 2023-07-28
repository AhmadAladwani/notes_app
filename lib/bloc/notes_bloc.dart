import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revise_notes/bloc/notes_event.dart';
import 'package:revise_notes/bloc/notes_state.dart';
import 'package:revise_notes/notes_respository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;
  NotesBloc({required this.notesRepository})
      : super(const NotesStateLoading()) {
    on<NotesEventLoadNotes>(
      (event, emit) async {
        final userId = event.userId;
        final notes = await notesRepository.getNotes(userId);
        emit(NotesStateLoaded(notes: notes));
      },
    );
    on<NotesEventAdd>(
      (event, emit) async {
        emit(const NotesStateLoading());
        final userId = event.userId;
        final title = event.title;
        final description = event.description;
        await notesRepository.insert(
          userId,
          title,
          description,
        );
        final notes = notesRepository.notes;
        emit(NotesStateLoaded(notes: notes));
      },
    );
    on<NotesEventDelete>(
      (event, emit) async {
        emit(const NotesStateLoading());
        final userId = event.userId;
        final noteId = event.noteId;
        await notesRepository.delete(
          userId,
          noteId,
        );
        final notes = notesRepository.notes;
        emit(NotesStateLoaded(notes: notes));
      },
    );
    on<NotesEventUpdate>(
      (event, emit) async {
        emit(const NotesStateLoading());
        final userId = event.userId;
        final noteId = event.noteId;
        final title = event.title;
        final description = event.description;
        await notesRepository.update(userId, noteId, title, description);
        final notes = notesRepository.notes;
        emit(NotesStateLoaded(notes: notes));
      },
    );
  }
}
