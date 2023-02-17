import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../business_search.dart';

class BusinessRegistrationPage extends StatefulWidget {
  const BusinessRegistrationPage({Key? key}) : super(key: key);

  @override
  _BusinessRegistrationPageState createState() =>
      _BusinessRegistrationPageState();
}

class _BusinessRegistrationPageState extends State<BusinessRegistrationPage> {
  // Define variables for storing user input
  String? _businessName,
      _streetAddress,
      _zipcode,
      _hours,
      _race,
      _description,
      _ownerName,
      _phoneNumber,
      _website,
      _logo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Business Name'),
              onChanged: (input) {
                setState(() {
                  _businessName = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Street Address'),
              onChanged: (input) {
                setState(() {
                  _streetAddress = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Zipcode'),
              onChanged: (input) {
                setState(() {
                  _zipcode = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Hours'),
              onChanged: (input) {
                setState(() {
                  _hours = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Race'),
              onChanged: (input) {
                setState(() {
                  _race = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (input) {
                setState(() {
                  _description = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Owner Name'),
              onChanged: (input) {
                setState(() {
                  _ownerName = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              onChanged: (input) {
                setState(() {
                  _phoneNumber = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Website'),
              onChanged: (input) {
                setState(() {
                  _website = input!;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Logo'),
              onChanged: (input) {
                setState(() {
                  _logo = input!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // TODO: Save the user input to a database or file
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Registration Successful'),
                      content: Text('Thank you for registering your business.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FirstRoute(title: 'Business List')),
                            );
                            //submit business information to Firebase needs to be implemented
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
