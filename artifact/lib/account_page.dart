import 'package:artifact/BusinessRegistrationPage.dart';
import 'package:artifact/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../business_search.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _gender, _ethnicity;
  int? _age;
  bool? _isLGBTQ = false;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Map<String, Object>? previousInfo = Map<String, Object>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInformation(uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          initializeInfo();
          return Scaffold(
            appBar: AppBar(
              title: Text('Account Page'),
              backgroundColor: Colors.blueGrey,
              automaticallyImplyLeading: false,
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
                      initialValue: _name,
                      validator: (input) =>
                          input == null ? 'Invalid Name' : null,
                      onChanged: (input) => setState(() => _name = input!),
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your age',
                      ),
                      initialValue: "$_age",
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
                      //small issue here. clicking reloads the page, which with initializeInfo() means it cannot be changed. but without it always defaults to false
                      title: Text("LGBTQ+?"),
                      value: _isLGBTQ,
                      onChanged: (newValue) {
                        setState(() {
                          _isLGBTQ = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     Map<String, Object>? testData = Map<String, Object>();
                    //     testData.addAll({
                    //       "Name": _name!,
                    //       "Age": _age!,
                    //       "Gender": _gender!,
                    //       "LQBTQ+": _isLGBTQ!,
                    //       "Race": _ethnicity!
                    //     });
                    //     CollectionReference usersRef =
                    //         FirebaseFirestore.instance.collection('Accounts');
                    //     usersRef.doc(uid).update(testData);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomeScreen()),
                    //     );
                    //     //_submit uncomment when submit implemented
                    //   },
                    //   child: Text('Save'),
                    // ),
                    TextButton(
                      //creates a button that contains a name of a business in it
                      child: Container(
                        color: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                      onPressed: () {
                        Map<String, Object>? testData = Map<String, Object>();
                        testData.addAll({
                          "Name": _name!,
                          "Age": _age!,
                          "Gender": _gender!,
                          "LQBTQ+": _isLGBTQ!,
                          "Race": _ethnicity!
                        });
                        CollectionReference usersRef =
                            FirebaseFirestore.instance.collection('Accounts');
                        usersRef.doc(uid).update(testData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                        //_submit uncomment when submit implemented
                      },
                    ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => BusinessRegistrationPage()),
                    //     );
                    //     //_submit uncomment when submit implemented
                    //   },
                    //   child: Text('Add a Business'),
                    // ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                    TextButton(
                        //creates a button that contains a name of a business in it
                        child: Container(
                          color: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: const Text(
                            "Add a Business",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BusinessRegistrationPage()),
                          );
                        })
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout_outlined),
                  label: 'Logout',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.filter_list), label: "Filters"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Account',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search All',
                ),
              ],
              selectedItemColor: Colors.blueGrey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.black,
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  int _selectedIndex = 2;
  Map<String, int> defaultMap = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // The line below usually is preceded with the keyword 'await' but this
      // threw errors due to the method not being an async method.
      FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FirstRoute(
            title: 'Search',
            receivedMap: defaultMap,
          ),
        ),
      );
    }
  }

  void initializeInfo() {
    _name = "${previousInfo!['Name']}";
    _age = previousInfo!['Age'] as int?;
    _gender = "${previousInfo!['Gender']}";
    _ethnicity = "${previousInfo!['Race']}";
    //_isLGBTQ = previousInfo!['LQBTQ+'] as bool?;
  }

  Future<QuerySnapshot> getInformation(uid) async {
    //gets information of the user (by name) and puts into a hashmap
    var retVal = Map<String, Object>(); //temp hashmap for collection

    // gets a document from the collection if it exists and retrieves its info
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Accounts');
    businesses.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      //creates a snapshot for the user by name
      if (documentSnapshot.exists) {
        //checks if the user with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        documentFields?.forEach((key, value) {
          //collects the data from a hashmap and moves to temp hashmap (inefficient, make better later)
          retVal.addAll({"$key": documentFields["$key"]});
        });
      }
    });
    previousInfo = retVal; //sets previousInfo equal to temp hashmap
    return await FirebaseFirestore.instance.collection('Accounts').get();
  }
}
