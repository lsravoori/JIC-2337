import 'package:artifact/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text('User Registration Page'),
        backgroundColor: const Color(0xFFD67867),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text('Please input the information to creat an account'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (input) => input == null ? 'Invalid Name' : null,
                onChanged: (input) => setState(() => _name = input!),
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Woman', 'Man', 'Non-binary', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                validator: (input) =>
                    input == null ? 'Please select a gender' : null,
                onChanged: (input) => setState(() => _gender = input!),
                onSaved: (input) => _gender = input!,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Ethnicity'),
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
                          value: ethnicity,
                          child: Text(ethnicity),
                        ))
                    .toList(),
                validator: (input) =>
                    input == null ? 'Please select an ethnicity' : null,
                onChanged: (input) => setState(() => _ethnicity = input!),
                onSaved: (input) => _ethnicity = input!,
              ),
              CheckboxListTile(
                title: const Text("LGBTQ+?"),
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
                  Map<String, Object>? testData = <String, Object>{};
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
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                  //_submit uncomment when submit implemented
                },
                child: Container(
                  color: const Color(0xFFD67867),
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
}
