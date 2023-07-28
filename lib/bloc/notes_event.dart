import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesEvent {
  const NotesEvent();
}

@immutable
class NotesEventLoadNotes extends NotesEvent {
  final String userId;
  const NotesEventLoadNotes({required this.userId});
}

@immutable
class NotesEventAdd extends NotesEvent {
  final String userId;
  final String title;
  final String description;

  const NotesEventAdd({
    required this.userId,
    required this.title,
    required this.description,
  });
}

@immutable
class NotesEventDelete extends NotesEvent {
  final String userId;
  final int noteId;
  const NotesEventDelete({
    required this.userId,
    required this.noteId,
  });
}

@immutable
class NotesEventUpdate extends NotesEvent {
  final String userId;
  final int noteId;
  final String title;
  final String description;
  const NotesEventUpdate({
    required this.userId,
    required this.noteId,
    required this.title,
    required this.description,
  });
}
