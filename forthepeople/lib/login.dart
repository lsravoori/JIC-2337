import 'package:flutter/material.dart';
import '../../../business_search.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2329),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logodone.JPG'),
              TextButton(
                  //creates a button that contains a name of a business in it
                  child: Container(
                    color: const Color(0xFFD67867),
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Enter Here",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
