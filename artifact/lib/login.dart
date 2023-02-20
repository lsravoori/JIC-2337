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
      appBar: AppBar(
        title: const Text(
          'For The People: Login',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white24,
      body: Form(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, '/');
            //   },
            //   child: const Text(
            //     'Enter Here',
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            TextButton(
                //creates a button that contains a name of a business in it
                child: Container(
                  color: Colors.blueGrey,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    "Enter Here",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                })
          ],
        ),
      ),
    );
  }
}
