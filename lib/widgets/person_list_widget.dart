import 'package:flutter/material.dart';

import '../model/person.dart';

class PersonListWidget extends StatelessWidget {
  const PersonListWidget({super.key, required persons, required onDeleteItem}) :
        _persons = persons, _onDeleteItem = onDeleteItem;
  final List<Person> _persons;
  final Function(Person) _onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(
      _persons.length,
      (int index) {
        Person person = _persons[index];
        return PersonItemWidget(
            person: person,
          onDelete: _onDeleteItem,
        );
      },
    ));
  }
}

class PersonItemWidget extends StatelessWidget {
   PersonItemWidget({super.key, required person, required onDelete}) :
        _person = person, _onDelete = onDelete;

  final Person _person;
  final Function(Person) _onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 10.0,
      child: ListTile(
        leading: Text('${_person.id}'),
        title: Row(
          children: [
            Text('${_person.name}'),
            Expanded(

              child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${_person.age}'),
              ],
            ),)
          ],
        ),
        trailing: IconButton(
            onPressed: (){
              _onDelete(_person);
            },
            icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
