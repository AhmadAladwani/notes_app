import 'package:path/path.dart';
import 'package:revise_notes/constants.dart';
import 'package:revise_notes/models/notes.dart';
import 'package:sqflite/sqflite.dart';

class SqliteProvider {
  late final Database _database;
  bool _databaseInitialized = false;

  Future<void> open() async {
    if (!_databaseInitialized) {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'notes.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async => await db.execute(
            'CREATE TABLE $tableNotes ($columnId INTEGER PRIMARY KEY, $columnUserId TEXT NOT NULL, $columnTitle TEXT NOT NULL, $columnDescription TEXT NOT NULL)'),
      );
      _databaseInitialized = true;
    } else {
      print('This should not be printed');
    }
  }

  Future<List<Note>> getNotesFromDatabase(String userId) async {
    await open();
    final notesFromDatabase = await _database.query(
      tableNotes,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
    final notes = notesFromDatabase
        .map(
          (note) => Note(
              id: note[columnId] as int,
              title: note[columnTitle] as String,
              description: note[columnDescription] as String),
        )
        .toList();
    return notes;
  }

  Future<int> insertInDatabase(
      String userId, String title, String description) async {
    final values = {
      columnUserId: userId,
      columnTitle: title,
      columnDescription: description,
    };
    final noteId = await _database.insert(
      tableNotes,
      values,
    );
    return noteId;
  }

  Future<void> deleteFromDatabase(int noteId) async {
    await _database.delete(
      tableNotes,
      where: "$columnId = ?",
      whereArgs: [noteId],
    );
  }

  Future<void> updateInDatabase(
      int noteId, String title, String description) async {
    final values = {
      columnTitle: title,
      columnDescription: description,
    };
    await _database.update(
      tableNotes,
      values,
      where: "$columnId = ?",
      whereArgs: [noteId],
    );
  }
}
