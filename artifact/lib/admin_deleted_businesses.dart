import 'package:flutter/material.dart';
import '../../../functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDeletedScreen extends StatefulWidget {
  const AdminDeletedScreen({super.key});
  @override
  State<AdminDeletedScreen> createState() => _AdminDeletedScreen();
}

class _AdminDeletedScreen extends State<AdminDeletedScreen> {
  Map<String, int> defaultMap = {};
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen

  Future<QuerySnapshot> getData() async {
    list.clear(); //start blank slate
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    int i = 0;
    await FirebaseFirestore
        .instance //this whole section pulls business names in with a for each loop
        .collection('DeletedBusinesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (defaultMap.isEmpty ||
            defaultMap.containsKey(doc["Category"]) ||
            defaultMap.containsKey(doc["Zipcode"].toString())) {
          //filters based on incoming map
          i++;

          list.add(Functions.getAdminCard(_selectedIndex, context, doc));
          list.add(const Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
          )); //Divider
        }
      });
    });

    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  int _selectedIndex = 1; //this is the page we are on

  Scaffold makeScaffold() {
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'Deleted Businesses',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: const Color(0xFFD67867),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list),
        ),
        bottomNavigationBar: Functions.adminNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTapAdmin(index, context);
        }));
  }

  @override
  Widget build(BuildContext context) {
    //builds the UI screen
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeScaffold();
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
