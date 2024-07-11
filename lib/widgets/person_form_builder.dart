import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_sqflite/model/person.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class PersonFormBuilder extends StatefulWidget {
  const PersonFormBuilder(
      {super.key, required formKey, required onValidate, required onCancel})
      : _formKey = formKey,
        _onValidate = onValidate,
        _onCancel = onCancel;
  final GlobalKey<FormBuilderState> _formKey;
  final Function(Person person) _onValidate;
  final Function() _onCancel;

  @override
  State<PersonFormBuilder> createState() => _PersonFormBuilderState();
}

class _PersonFormBuilderState extends State<PersonFormBuilder> {
  final _nameFieldKey = GlobalKey<FormBuilderFieldState>();
  final _ageFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: widget._formKey,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadiusDirectional.all(Radius.circular(5.0)),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: widget._onCancel,
                icon: const Icon(Icons.close),
              ),
            ),
            FormBuilderTextField(
              key: _nameFieldKey,
              name: 'name',
              decoration: const InputDecoration(
                  labelText: 'Name', hintText: 'Enter your full name'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(3),
              ]),
            ),
            FormBuilderSlider(
              decoration: const InputDecoration(labelText: 'Age'),
              activeColor: Theme.of(context).colorScheme.secondary,
              key: _ageFieldKey,
              name: 'Age',
              initialValue: 20,
              min: 1,
              numberFormat: NumberFormat("#0"),
              valueTransformer: (value) => value!.floor(),
              max: 120,
            ),
            const SizedBox(
              height: 5.0,
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () {
                // Validate and save the form values
                widget._formKey.currentState?.saveAndValidate();
                debugPrint(widget._formKey.currentState?.value.toString());

                // On another side, can access all field values without saving form with instantValues
                var isValidated = widget._formKey.currentState!.validate();
                debugPrint(
                    widget._formKey.currentState?.instantValue.toString());
                if (isValidated) {
                  String name = _nameFieldKey.currentState!.value;
                  int age =
                      (_ageFieldKey.currentState!.value as double).round();
                  var person = Person(name: name, age: age);
                  widget._onValidate(person);
                }
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
