import 'package:flutter/material.dart';
import 'package:artifact/main.dart';
import 'package:artifact/business_search.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (input) => _email = input!,
              decoration: InputDecoration(labelText: 'Email'),
            ), //textfield for an email input
            TextFormField(
              onSaved: (input) => _password = input!,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ), //textfield for a password input
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Perform login here, WIP
                }
              },
              child: Text('Sign in'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to forgot password screen, WIP
              },
              child: Text('Forgot Password'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to register screen, WIP
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FirstRoute(title: 'Business List')),
                );
              },
              child: Text('Continue as guest'),
            ) //button continues to business_search.dart page (searches are done as a guest)
          ],
        ),
      ),
    );
  }
}
