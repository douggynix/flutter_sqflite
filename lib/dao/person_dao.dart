import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../model/person.dart';

class PersonDao {
  const PersonDao({database}) : _db = database;

  final Database _db;
  static const String _tblName = "person";

  Future<void> insertPerson(Person person) async {
    int? rowsInserted;
    try {
      rowsInserted = await _db.insert(_tblName, person.toMap());
    } catch (e) {
      debugPrint('Failed to insert $person with error : $e');
      rethrow;
    }

    debugPrint('Rows inserted for $person : $rowsInserted');
  }

  Future<List<Person>> getPersons() async {
    List<Map<String, Object?>> result = await _db.query(_tblName);

    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in result)
        Person(id: id, name: name, age: age)
    ];
  }

  Future<void> deletePerson(Person person) async {
    int rowsDeleted =
        await _db.rawDelete('delete from $_tblName where id = ${person.id}');
    debugPrint('Rows delete for $person : $rowsDeleted');
  }
}
