import 'package:artifact/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _name, _gender, _ethnicity;
  int? _age;
  bool? _isLGBTQ = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (input) => input == null ? 'Invalid Name' : null,
                onChanged: (input) => setState(() => _name = input!),
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) => _age = int.parse(value!),
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Woman', 'Man', 'Non-binary', 'Other']
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
                  'Middle Eastern',
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
              CheckboxListTile(
                title: Text("LGBTQ+?"),
                value: _isLGBTQ,
                onChanged: (newValue) {
                  setState(() {
                    _isLGBTQ = newValue!;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, Object>? testData = Map<String, Object>();
                  testData.addAll({
                    "Name": _name!,
                    "Age": _age!,
                    "Gender": _gender!,
                    "LGBTQ+": _isLGBTQ!,
                    "Race": _ethnicity!,
                    "isAdmin": false,
                    "BusinessIDs": []
                  });
                  CollectionReference usersRef =
                      FirebaseFirestore.instance.collection('Accounts');
                  final auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final uid = user?.uid;
                  usersRef.doc(uid).set(testData);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  //_submit uncomment when submit implemented
                },
                child: Container(
                  color: Colors.blueGrey,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
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
