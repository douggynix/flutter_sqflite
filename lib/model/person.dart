class Person {
  late final int? _id;
  final String _name;
  final int _age;

  Person({id, required name, required age})
      : _id = id,
        _name = name,
        _age = age;

  int? get id => _id;

  int get age => _age;

  String get name => _name;

  Map<String, Object?> toMap() {
    return {
      'id': _id,
      'name': _name,
      'age': _age,
    };
  }

  @override
  String toString() {
    return 'Person{_id: $_id, _name: $_name, _age: $_age}';
  }
}
