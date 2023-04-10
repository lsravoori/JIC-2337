import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../admin.dart';
import '../../../functions.dart';

class AdminBusinessInfo extends StatefulWidget {
  const AdminBusinessInfo({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final int number; //number is used for selected index logic for nav bar
  // Below, _BusinessInfoState passes in the string "title" which is the business id
  @override
  State<AdminBusinessInfo> createState() => _AdminBusinessInfo(title, number);
}

class _AdminBusinessInfo extends State<AdminBusinessInfo> {
  var business = ""; //name of the business
  Map<String, Object>? businessInfo =
      <String, Object>{}; //hashmap of the business details
  List<Widget> infoList =
      []; //unused for now, but will be used for creation of the scaffold
  int number = 3;
  double _rating = 0;
  double avgRating = 0;

  _AdminBusinessInfo(this.business, this.number) {
    getInformation(business);
    //this.infoList = createInfoWidgets(businessInfo); //unused for now, will probably delete/repurpose
  }

  Future<QuerySnapshot> getInformation(business) async {
    _selectedIndex = number;
    //gets information of the businesses (by name) and puts into a hashmap
    var retVal = <String, Object>{}; //temp hashmap for collection

    // gets a document from the collection if it exists and retrieves its info
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    businesses.doc(business).get().then((DocumentSnapshot documentSnapshot) {
      //creates a snapshot for the business by name
      if (documentSnapshot.exists) {
        //checks if the business with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        documentFields?.forEach((key, value) {
          //collects the from a hashmap and moves to temp hashmap (inefficient, make better later)
          retVal.addAll({key: documentFields[key]});
        });
      }
    });
    businessInfo = retVal; //sets businessInfo equal to temp hashmap
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  List<Widget> createInfoWidgets(businessInfo) {
    //unused method, possibly delete
    var widgets = <Widget>[];
    //var widgetKeys = businessInfo.keys;
    businessInfo.forEach((key, value) {
      widgets.add(Text("$key" ": " "$value"));
    });
    return widgets;
  }

  Scaffold makeSecondScaffold() {
    //makes the scaffold for the business_info page
    Map<String, dynamic> ratingMap =
        businessInfo!['Ratings'] as Map<String, dynamic>;
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: Functions.businessAppBar(
            _rating, ratingMap, "$uid", avgRating, businessInfo),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Functions.displayInfo("Logo: ${businessInfo!['Logo']}"),
              Functions.divider(),
              Functions.displayInfo(
                  "Details: ${businessInfo!['Business Details']}"),
              Functions.divider(),
              Functions.displayInfo("Category: ${businessInfo!['Category']}"),
              Functions.divider(),
              Functions.displayInfo(
                  "Phone Number: ${businessInfo!['Phone Number']}"),
              Functions.divider(),
              Functions.displayInfo("Hours: ${businessInfo!['Hours']}"),
              Functions.divider(),
              Functions.displayInfo("Address: ${businessInfo!['Street Name']}"),
              Functions.divider(),
              Functions.displayInfo("Zipcode: ${businessInfo!['Zipcode']}"),
              Functions.divider(),
              Functions.displayInfo("Website: ${businessInfo!['Website']}"),
              Functions.divider(),
              const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 2, 2),
                  child: Text("Actions:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15))),
              TextButton(
                child: Container(
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: const Text(
                    "Remove Business",
                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                        'Are you sure you want to remove this business?'),
                    content: const Text('This cannot be undone.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Remove');
                          deleteBusiness(business, businessInfo);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AdminScreen(),
                            ),
                          );
                        },
                        child: const Text('REMOVE'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                child: Container(
                    color: Colors.lightGreenAccent,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: const Text(
                      "Clear Flags",
                      style: TextStyle(fontSize: 10.0),
                    )),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                        'Are you sure you want to clear the flags for this business?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          CollectionReference busRef = FirebaseFirestore
                              .instance
                              .collection('Businesses');
                          busRef.doc(business).update({"Flag Count": 0});
                          busRef
                              .doc(business)
                              .update({"Flag Reasons.Inaccurate": 0});
                          busRef
                              .doc(business)
                              .update({"Flag Reasons.Inappropriate": 0});
                          busRef
                              .doc(business)
                              .update({"Flag Reasons.Other": 0});
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Functions.adminNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTapAdmin(index, context);
        }));
  }

  void deleteBusiness(String business, Map<String, Object>? businessInfo) {
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    CollectionReference delBusinesses =
        FirebaseFirestore.instance.collection('DeletedBusinesses');
    CollectionReference users =
        FirebaseFirestore.instance.collection('Accounts');
    businesses.doc(business).get().then((DocumentSnapshot documentSnapshot) {
      //creates a snapshot for the business by name
      if (documentSnapshot.exists) {
        //checks if the business with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (documentFields != null) {
          //Find out the userID below and remove businessID from their list of businesses.
          if (documentFields.keys.toList().contains("UserID")) {
            String userID = documentFields["UserID"];
            users.doc(userID).get().then((DocumentSnapshot userSnapshot) {
              if (userSnapshot.exists) {
                Map<String, dynamic>? userFields =
                    userSnapshot.data() as Map<String, dynamic>?;
                if (userFields != null) {
                  if (userFields.keys.toList().contains("BusinessIDs")) {
                    List businessIDS = userFields["BusinessIDs"];
                    businessIDS.remove(documentSnapshot.id);
                    FirebaseFirestore.instance
                        .collection('Accounts')
                        .doc(userID)
                        .update({'BusinessIDs': businessIDS});
                  }
                }
              }
            });
          }
          //Copy business document from the 'Businesses' collection to the 'DeletedBusinesses' collection
          delBusinesses
              .doc(business)
              .get()
              .then((DocumentSnapshot delDocSnapshot) {
            FirebaseFirestore.instance
                .collection('DeletedBusinesses')
                .doc(documentSnapshot.id)
                .set(documentFields);
          });
        }
        businesses.doc(business).delete();
      }
    });
  }

  int _selectedIndex = 2;
  Map<String, int> random = {};

  @override
  Widget build(BuildContext context) {
    //builds the UI for this page
    return FutureBuilder(
      future: getInformation(business),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeSecondScaffold();
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
