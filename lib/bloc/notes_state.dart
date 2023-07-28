import 'package:flutter/foundation.dart' show immutable;
import 'package:revise_notes/models/notes.dart';

@immutable
abstract class NotesState {
  const NotesState();
}

@immutable
class NotesStateLoading extends NotesState {
  const NotesStateLoading();
}

@immutable
class NotesStateLoaded extends NotesState {
  final List<Note> notes;
  const NotesStateLoaded({required this.notes});
}
