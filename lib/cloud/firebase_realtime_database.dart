import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  final _ref = FirebaseDatabase.instance.ref('users');

  Future<void> insertInDatabase(
      String userId, int noteId, String title, String description) async {
    await _ref.child('$userId/$noteId').set(
      {
        'title': title,
        'description': description,
      },
    );
  }

  Future<void> deleteFromDatabase(String userId, int noteId) async {
    await _ref.child('$userId/$noteId').remove();
  }

  Future<void> updateInDatabase(
      String userId, int noteId, String title, String description) async {
    final values = {
      'title': title,
      'description': description,
    };
    _ref.child('$userId/$noteId').update(values);
  }
}
