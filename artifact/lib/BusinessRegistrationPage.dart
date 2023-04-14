import 'package:artifact/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
      _state,
      _hours,
      _category,
      _description,
      _ownerName,
      _ethnicity,
      _gender,
      _phoneNumber,
      _website;
  String _logo = "";
  int? _zipcode;
  bool? _isLGBTQ = false;
  Uint8List? logo;
  String? logoName;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Registration'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text('Please input all information to add your business.'),
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Business Name'),
                onChanged: (input) => setState(() => _businessName = input!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Street Address'),
                onChanged: (input) => setState(() => _streetAddress = input!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                onChanged: (input) => setState(() => _state = input!)),
            DropdownButtonFormField(
              decoration:
                  const InputDecoration(labelText: 'Category of Business'),
              value: _category,
              items: [
                "Women",
                "Non-Binary",
                "LGBT+",
                "Black",
                "Hispanic",
                "Asian",
                "Pacific Islander",
                "Native American",
                "Middle Eastern"
              ]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (input) => setState(() => _category = input!),
              onSaved: (input) => _category = input!,
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Zipcode'),
                onChanged: (value) => _zipcode = int.parse(value!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Hours'),
                onChanged: (input) => setState(() => _hours = input!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (input) => setState(() => _description = input!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Owner\'s Name'),
                onChanged: (input) => setState(() => _ownerName = input!)),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Owner\'s Gender'),
              value: _gender,
              items: ['Woman', 'Man', 'Non-binary', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
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
                'Asian',
                'Pacific Islander',
                'Native American',
                'Other'
              ]
                  .map((ethnicity) => DropdownMenuItem(
                        value: ethnicity,
                        child: Text(ethnicity),
                      ))
                  .toList(),
              //validator: (input) =>
              //input == null ? 'Please select an ethnicity' : null,
              onChanged: (input) => setState(() => _ethnicity = input!),
              onSaved: (input) => _ethnicity = input!,
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (input) => setState(() => _phoneNumber = input!)),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Website'),
                onChanged: (input) => setState(() => _website = input!)),
            TextButton(
              onPressed: selectFile,
              child: Container(
                color: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: const Text(
                  "Add Logo",
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
            ),
            CheckboxListTile(
              title: const Text("LGBTQ+ owned?"),
              value: _isLGBTQ,
              onChanged: (value) => setState(() => _isLGBTQ = value!),
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: Container(
                color: Colors.blueGrey,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
              onPressed: () {
                // Todo: Save the user input to a database or file
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Registration Successful'),
                      content: const Text(
                          'Thank you for registering your business.'),
                      actions: <Widget>[
                        TextButton(
                          child: Container(
                            color: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                          onPressed: () async {
                            Map<String, Object>? testData =
                                Map<String, Object>();
                            Map<String, int>? reasonsMap = Map<String, int>();
                            reasonsMap.addAll({
                              "Inaccurate": 0,
                              "Inappropriate": 0,
                              "Other": 0
                            });
                            Map<String, int>? _rating = Map<String, int>();
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
                              "Ratings": _rating,
                              "Verified": false,
                              "Flag Count": 0,
                              "Flag Reasons": reasonsMap
                            });
                            CollectionReference busRef = FirebaseFirestore
                                .instance
                                .collection('Businesses');
                            final auth = FirebaseAuth.instance;
                            final User? user = auth.currentUser;
                            final uid = user?.uid;
                            testData.addAll({"UserID": uid!});
                            DocumentReference docRef = await busRef.add(testData);
                            String docID = docRef.id;

                            var doc_id = [];
                            await FirebaseFirestore.instance
                                .collection('Businesses')
                                .where("UserID", isEqualTo: uid)
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                doc_id.add(doc.id);
                              });
                            });
                            CollectionReference userRef = FirebaseFirestore
                                .instance
                                .collection('Accounts');
                            userRef.doc(uid).update(
                                {"BusinessIDs": FieldValue.arrayUnion(doc_id)});

                            // UPLOADING LOGO HERE
                            if (logo != null) {
                              uploadFile(uid, docID);
                            }
                            busRef.doc(docID).update(
                                {"Logo": 'logos/' + docID + '/' + logoName!});
                            //

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                            //Todo: properly route the register button to homepage
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'bmp', 'gif'],
      );
    if (result == null) {
      return;
    }
    setState(() {
      logo = result.files.single.bytes;
      logoName = result.files.single.name;
    });
  }

  Future uploadFile(String uid, String docID) async {
    final path = 'logos/' + docID + '/' + logoName!;

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putData(logo!);

    final snapshot = await uploadTask!.whenComplete(() {});
  }
}
