import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> insertInDatabase(
      String userId, int noteId, String title, String description) async {
    final values = {
      'title': title,
      'description': description,
    };
    await firebaseFirestore
        .collection(userId)
        .doc(noteId.toString())
        .set(values);
  }

  Future<void> deleteFromDatabase(String userId, int noteId) async {
    await firebaseFirestore.collection(userId).doc(noteId.toString()).delete();
  }

  Future<void> updateInDatabase(
      String userId, int noteId, String title, String description) async {
    final updatedValues = {
      'title': title,
      'description': description,
    };
    await firebaseFirestore
        .collection(userId)
        .doc(noteId.toString())
        .update(updatedValues);
  }
}
