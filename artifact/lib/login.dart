import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import '../../../main.dart';
import '../../../business_search.dart';
import '../../../RegistrationPage.dart';
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
      appBar: AppBar(
        title: const Text(
          'For The People: Login',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white24,
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
              decoration: const InputDecoration(labelText: 'Email'),
            ), //textfield for an email input
            TextFormField(
              onSaved: (input) => _password = input!,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ), //textfield for a password input
            const Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Perform login here, WIP
                }
              },
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to forgot password screen, WIP
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _navigateToNextScreen(context);
              },
              child: const Text('Create Account',
                  style: TextStyle(color: Colors.black)),
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
              child: const Text('Continue as guest',
                  style: TextStyle(color: Colors.black)),
            ) //button continues to business_search.dart page (searches are done as a guest)
          ],
        ),
      ),
    );
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationPage()));
  }
}
