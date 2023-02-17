import 'package:flutter/material.dart';
import '../../../login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../business_search.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _username, _password, _gender, _ethnicity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Woman', 'Man', 'Non-binary', 'Transgender']
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                validator: (input) =>
                    input == null ? 'Please select a gender' : null,
                onChanged: (input) => setState(() => _gender = input!),
                onSaved: (input) => _gender = input!,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Ethnicity'),
                value: _ethnicity,
                items: [
                  'White',
                  'Black',
                  'Hispanic',
                  'Asian',
                  'Pacific Islander',
                  'Native American',
                  'Two or More Ethnicities',
                  'Other'
                ]
                    .map((ethnicity) => DropdownMenuItem(
                          child: Text(ethnicity),
                          value: ethnicity,
                        ))
                    .toList(),
                validator: (input) =>
                    input == null ? 'Please select an ethnicity' : null,
                onChanged: (input) => setState(() => _ethnicity = input!),
                onSaved: (input) => _ethnicity = input!,
              ),
              MaterialButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const FirstRoute(title: 'Business List')),
                  );*/
                  //_submit uncomment when submit implemented
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // void _submit() async {
  // Todo implement firebase auth when submit is pressed
  //}
}
