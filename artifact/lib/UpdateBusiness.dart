import 'package:artifact/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../business_search.dart';

class UpdateBusiness extends StatefulWidget {
  const UpdateBusiness({
    super.key,
    required this.title,
  });

  final String title;
  @override
  State<UpdateBusiness> createState() => _UpdateBusinessState(title);
}

class _UpdateBusinessState extends State<UpdateBusiness> {
  // Define variables for storing user input
  String busID = "";
  String? _businessName,
      _streetAddress,
      _state,
      _hours,
      _category,
      _description,
      _ownerName,
      _ethnicity,
      _gender,
      _phoneNumber,
      _website,
      _logo;
  int? _zipcode;
  bool? _isLGBTQ = false;
  bool firstUpdate = false;
  Map<String, Object>? previousInfo = Map<String, Object>();

  _UpdateBusinessState(String businessID) {
    this.busID = businessID;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInformation(busID),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          initializeInfo();
          return Scaffold(
            appBar: AppBar(
              title: Text('Business Registration'),
              backgroundColor: Colors.blueGrey,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Business Name'),
                      initialValue: _businessName,
                      onChanged: (input) =>
                          setState(() => _businessName = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Street Address'),
                      initialValue: _streetAddress,
                      onChanged: (input) =>
                          setState(() => _streetAddress = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'State'),
                      initialValue: _state,
                      onChanged: (input) => setState(() => _state = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Category'),
                      initialValue: _category,
                      onChanged: (input) => _category = input!),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Zipcode'),
                      initialValue: '$_zipcode',
                      onChanged: (value) => _zipcode = int.parse(value!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Hours'),
                      initialValue: _hours,
                      onChanged: (input) => setState(() => _hours = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: _description,
                      onChanged: (input) =>
                          setState(() => _description = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Owner\'s Name'),
                      initialValue: _ownerName,
                      onChanged: (input) =>
                          setState(() => _ownerName = input!)),
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
                      'Other'
                    ]
                        .map((ethnicity) => DropdownMenuItem(
                              child: Text(ethnicity),
                              value: ethnicity,
                            ))
                        .toList(),
                    //validator: (input) =>
                    //input == null ? 'Please select an ethnicity' : null,
                    onChanged: (input) => setState(() => _ethnicity = input!),
                    onSaved: (input) => _ethnicity = input!,
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      initialValue: _phoneNumber,
                      onChanged: (input) =>
                          setState(() => _phoneNumber = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Website'),
                      initialValue: _website,
                      onChanged: (input) => setState(() => _website = input!)),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Logo'),
                      initialValue: _logo,
                      onChanged: (input) => setState(() => _logo = input!)),
                  CheckboxListTile(
                    title: Text("LGBTQ+ owned?"),
                    value: _isLGBTQ,
                    onChanged: (value) => setState(() => _isLGBTQ = value!),
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    child: Container(
                      color: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                    onPressed: () {
                      Map<String, Object>? testData = Map<String, Object>();
                      testData.addAll({
                        "Business Name": _businessName!,
                        "Street Name": _streetAddress!,
                        "State": _state!,
                        "Hours": _hours!,
                        "Category": _category!,
                        "Business Details":
                            _description!, //had to change attribute from Description to Details so show all screen didnt break
                        "Owner's Name": _ownerName!,
                        "Owner's Race": _ethnicity!,
                        "Owner's Gender": _gender!,
                        "Phone Number": _phoneNumber!,
                        "Website": _website!,
                        "Logo": _logo!,
                        "Owner's LGBTQ+": _isLGBTQ!,
                        "Zipcode": _zipcode!,
                      });
                      CollectionReference busRef =
                          FirebaseFirestore.instance.collection('Businesses');
                      final auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;
                      final uid = user?.uid;
                      testData.addAll({"UserID": uid!});
                      busRef.doc(busID).update(testData);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                      //Todo: properly route the register button to homepage
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  void initializeInfo() {
    if (firstUpdate == false) {
      _businessName = "${previousInfo!['Business Name']}";
      _streetAddress = "${previousInfo!["Street Name"]}";
      _state = "${previousInfo!["State"]}";
      _hours = "${previousInfo!["Hours"]}";
      _category = "${previousInfo!["Category"]}";
      _description = "${previousInfo!["Business Details"]}";
      _ownerName = "${previousInfo!["Owner's Name"]}";
      _ethnicity = "${previousInfo!["Owner's Race"]}";
      _gender = "${previousInfo!["Owner's Gender"]}";
      _phoneNumber = "${previousInfo!["Phone Number"]}";
      _website = "${previousInfo!["Website"]}";
      _logo = "${previousInfo!["Logo"]}";
      _zipcode = previousInfo!["Zipcode"] as int?;
      _isLGBTQ = previousInfo!["Owner's LGBTQ+"] as bool?;
      firstUpdate = true;
    }
  }

  Future<QuerySnapshot> getInformation(busid) async {
    //gets information of the user (by name) and puts into a hashmap
    var retVal = Map<String, Object>(); //temp hashmap for collection

    // gets a document from the collection if it exists and retrieves its info
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    businesses.doc(busid).get().then((DocumentSnapshot documentSnapshot) {
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
