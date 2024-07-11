import 'package:flutter/material.dart';

class PersonFormWidget extends StatefulWidget {
  const PersonFormWidget({super.key, required globalFormKey})
      : _formKey = globalFormKey;

  final GlobalKey<FormState> _formKey;

  @override
  State<PersonFormWidget> createState() => _PersonFormWidgetState();
}

class _PersonFormWidgetState extends State<PersonFormWidget> {
  final TextEditingController _nameFieldCtrl = TextEditingController();

  @override
  void dispose() {
    _nameFieldCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: widget._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormFieldWidget(textEditController: _nameFieldCtrl),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                //height: 60,
                //width: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget._formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Processing Data : ${_nameFieldCtrl.value.text}'),
                        ),
                      );
                      //widget._formKey.currentState!.reset();
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({super.key, required textEditController})
      : _txtEditCtrl = textEditController;

  final TextEditingController _txtEditCtrl;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //controller: widget._txtEditCtrl,

      decoration: const InputDecoration(
        filled: true,
        labelText: 'Name',
        labelStyle: TextStyle(fontSize: 20.0),
        hintText: 'Enter your full name here',
      ),
      //onEditingComplete: () => _formKey.currentS,
      onChanged: (value) {
        widget._txtEditCtrl.text = value;
      },
      onEditingComplete: () {
        setState(() {});
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }

        if (value.characters.length < 3) {
          return 'Full name Must contain at least 3 characters';
        }
        return null;
      },
    );
  }
}
