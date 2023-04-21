import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../functions.dart';

class AdminFlaggedInfo extends StatefulWidget {
  const AdminFlaggedInfo({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final int number; //number is used for selected index logic for nav bar
  // Below, _BusinessInfoState passes in the string "title" which is the business id
  @override
  State<AdminFlaggedInfo> createState() => _AdminFlaggedInfo(title, number);
}

class _AdminFlaggedInfo extends State<AdminFlaggedInfo> {
  var business = ""; //name of the business
  Map<String, Object>? businessInfo =
      <String, Object>{}; //hashmap of the business details
  List<Widget> infoList =
      []; //unused for now, but will be used for creation of the scaffold
  int number = 1;
  double _rating = 0;
  double avgRating = 0;

  _AdminFlaggedInfo(this.business, this.number) {
    getInformation(business);
    //this.infoList = createInfoWidgets(businessInfo); //unused for now, will probably delete/repurpose
  }

  Future<QuerySnapshot> getInformation(business) async {
    _selectedIndex = number;
    //gets information of the businesses (by name) and puts into a hashmap
    var retVal = <String, Object>{}; //temp hashmap for collection

    // gets a document from the collection if it exists and retrieves its info
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('DeletedBusinesses');
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
    }); //sets businessInfo equal to temp hashmap
    businesses = FirebaseFirestore.instance.collection('Businesses');
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
              Functions.adminInfoButtons(
                  context, business, businessInfo, _selectedIndex == 3),
              Functions.adminRemoveFlags(
                  context, business, businessInfo, _selectedIndex == 3),
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
