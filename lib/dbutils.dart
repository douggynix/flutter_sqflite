import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String dbBasePath = await getDatabasesPath();
  String dbFile = join(dbBasePath, "person.db");

  var database = openDatabase(
    dbFile,
    onCreate: (db, version) {
      db.execute('''
          CREATE TABLE person(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            age INTEGER)
          ''');
    },
    version: 1,
  );

  return database;
}
