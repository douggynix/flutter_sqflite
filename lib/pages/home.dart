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
  bool _isFormVisible = false;
  late Future<List<Person>> _futurePersonList;

  @override
  void initState() {
    super.initState();
    _futurePersonList = _retrievePersons();
  }

  Future<List<Person>> _retrievePersons() async {
    Database database = await dbHelper.getDatabase();
    _personDao = PersonDao(database: database);
    return _personDao.getPersons();
  }

  Set<FloatingActionButtonLocation> get _floatingBtnLocation => {
        MediaQuery.orientationOf(context) == Orientation.portrait
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat
      };

  void _onValidateForm(Person person) async {
    var _ = await _personDao.insertPerson(person);
    setState(() {
      _formKey.currentState!.reset();
      _futurePersonList = _retrievePersons();
      debugPrint('SetState is called');
      debugPrint('Person validated : $person');
    });
  }

  void _removeItem(Person person) async {
    var _ = await _personDao.deletePerson(person);
    setState(() {
      _futurePersonList = _retrievePersons();
    });
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
          child: FutureBuilder<List<Person>>(
            future: _futurePersonList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
              if (snapshot.hasData) {
                var persons = snapshot.requireData;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth > 600.0
                        ? WideViewWidget(
                            formKey: _formKey,
                            persons: persons,
                            isFormVisible: _isFormVisible,
                            onValidateForm: _onValidateForm,
                            onDeleteItem: _removeItem,
                            onCancelForm: _toggleForm)
                        : SmallViewWidget(
                            formKey: _formKey,
                            persons: persons,
                            isFormVisible: _isFormVisible,
                            onValidateForm: _onValidateForm,
                            onDeleteItem: _removeItem,
                            onCancelForm: _toggleForm);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
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

class SmallViewWidget extends StatelessWidget {
  final bool _isFormVisible;

  final GlobalKey<FormBuilderState> _formKey;

  final Function(Person) _onValidateForm;

  final Function() _onCancelForm;

  final List<Person> _persons;

  final Function(Person) _onDeleteItem;

  const SmallViewWidget(
      {super.key,
      required formKey,
      required persons,
      required isFormVisible,
      required onValidateForm,
      required onDeleteItem,
      required onCancelForm})
      : _persons = persons,
        _formKey = formKey,
        _isFormVisible = isFormVisible,
        _onValidateForm = onValidateForm,
        _onDeleteItem = onDeleteItem,
        _onCancelForm = onCancelForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: PersonListWidget(
            persons: _persons,
            onDeleteItem: _onDeleteItem,
          ),
        ),
        if (_isFormVisible)
          Expanded(
            flex: 4,
            child: PersonFormBuilder(
              formKey: _formKey,
              onValidate: _onValidateForm,
              onCancel: _onCancelForm,
            ),
          ),
      ],
    );
  }
}

class WideViewWidget extends SmallViewWidget {
  const WideViewWidget(
      {super.key,
      required super.formKey,
      required super.persons,
      required super.isFormVisible,
      required super.onValidateForm,
      required super.onCancelForm,
      required super.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isFormVisible)
          Expanded(
            flex: 4,
            child: PersonFormBuilder(
              formKey: _formKey,
              onValidate: _onValidateForm,
              onCancel: _onCancelForm,
            ),
          ),
        Expanded(
          flex: 5,
          child: PersonListWidget(
            persons: _persons,
            onDeleteItem: _onDeleteItem,
          ),
        ),
      ],
    );
  }
}
