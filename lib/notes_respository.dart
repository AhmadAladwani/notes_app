import 'package:revise_notes/cloud/firebase_realtime_database.dart';
import 'package:revise_notes/cloud/firebase_cloud_storage.dart';
import 'package:revise_notes/models/notes.dart';
import 'package:revise_notes/sqlite/sqlite_provider.dart';

class NotesRepository {
  final sqliteProvider = SqliteProvider();
  final firebaseCloudStorage = FirebaseCloudStorage();
  final firebaseRealtimeDatabase = FirebaseRealtimeDatabase();
  List<Note> notes = [];

  Future<List<Note>> getNotes(String userId) async {
    notes = await sqliteProvider.getNotesFromDatabase(userId);

    return notes;
  }

  Future<void> insert(String userId, String title, String description) async {
    final noteId = await sqliteProvider.insertInDatabase(
      userId,
      title,
      description,
    );
    await firebaseCloudStorage.insertInDatabase(
        userId, noteId, title, description);
    await firebaseRealtimeDatabase.insertInDatabase(
        userId, noteId, title, description);

    final note = Note(id: noteId, title: title, description: description);
    notes.add(note);
  }

  Future<void> delete(String userId, int noteId) async {
    await sqliteProvider.deleteFromDatabase(noteId);
    await firebaseCloudStorage.deleteFromDatabase(userId, noteId);
    await firebaseRealtimeDatabase.deleteFromDatabase(userId, noteId);

    notes.removeWhere((note) => note.id == noteId);
  }

  Future<void> update(
      String userId, int noteId, String title, String description) async {
    await sqliteProvider.updateInDatabase(noteId, title, description);
    await firebaseCloudStorage.updateInDatabase(
        userId, noteId, title, description);
    await firebaseRealtimeDatabase.updateInDatabase(
        userId, noteId, title, description);

    final noteIndex = notes.indexWhere((note) => note.id == noteId);
    notes[noteIndex] = Note(id: noteId, title: title, description: description);
  }
}
