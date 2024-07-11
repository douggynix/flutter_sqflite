import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_sqflite/dao/person_dao.dart';
import 'package:flutter_sqflite/widgets/person_form_builder.dart';
import 'package:flutter_sqflite/widgets/person_list_widget.dart';
import 'package:sqflite/sqflite.dart';

import '../dbutils.dart' as dbHelper;
import '../model/person.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late PersonDao _personDao;
  var _persons = <Person>[];
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
    _retrievePersons();
  }

  void _retrievePersons() async {
    Database database = await dbHelper.getDatabase();
    _personDao = PersonDao(database: database);
    _persons = await _personDao.getPersons();
    setState(() {});
  }

  Set<FloatingActionButtonLocation> get _floatingBtnLocation => {
        MediaQuery.orientationOf(context) == Orientation.portrait
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat
      };

  void _onValidateForm(Person person) async {
    var _ = await _personDao.insertPerson(person);
    _persons = await _personDao.getPersons();
    setState(() {
      _formKey.currentState!.reset();
      debugPrint('SetState is called');
      debugPrint('Person validated : $person');
    });
  }

  void _removeItem(Person person) async {
    var _ = await _personDao.deletePerson(person);
    _persons = await _personDao.getPersons();
    setState(() {});
  }

  void _toggleForm() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  //bool get _iscreenWide => MediaQuery.sizeOf(context).width > 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQFLite demo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 600.0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isFormVisible)
                          Expanded(
                              flex: 4,
                              child: PersonFormBuilder(
                                formKey: _formKey,
                                onValidate: _onValidateForm,
                                onCancel: _toggleForm,
                              )),
                        Expanded(
                          flex: 5,
                          child: PersonListWidget(
                            persons: _persons,
                            onDeleteItem: _removeItem,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: PersonListWidget(
                            persons: _persons,
                            onDeleteItem: _removeItem,
                          ),
                        ),
                        if (_isFormVisible)
                          Expanded(
                            flex: 4,
                            child: PersonFormBuilder(
                              formKey: _formKey,
                              onValidate: _onValidateForm,
                              onCancel: _toggleForm,
                            ),
                          ),
                      ],
                    );
            },
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: !_isFormVisible
            ? FloatingActionButton(
                child: const SizedBox(
                  child: Icon(Icons.add),
                ),
                onPressed: () => setState(() {
                  _isFormVisible = !_isFormVisible;
                }),
              )
            : const SizedBox(),
      ),
      floatingActionButtonLocation:
          !_isFormVisible ? _floatingBtnLocation.last : null,
    );
  }
}
