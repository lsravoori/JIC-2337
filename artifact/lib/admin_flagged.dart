import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';

class AdminFlagged extends StatefulWidget {
  const AdminFlagged({super.key, required this.title});
  final String title;

  @override
  State<AdminFlagged> createState() => _AdminFlagged();
}

class _AdminFlagged extends State<AdminFlagged> {
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen

  _AdminFlagged(); //makes instance of the map

  Future<QuerySnapshot> getData() async {
    //getData brings in all of the business from the database based on filters
    int i = 0;
    //used to number the amount of entries
    int j = 0;
    //used to check if empty page
    list.clear();
    //start blank slate
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    await FirebaseFirestore
        .instance //this whole section pulls business names in with a for each loop
        .collection('Businesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["Flag Count"] > 0) {
          //filters based on if there is a flag on a specific business
          i++;
          list.add(Functions.getAdminCard(_selectedIndex, context, doc));
          list.add(const Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
          )); //Divider
        }
      }
    });
    if (i == 0 && j == 0) {
      //done if there is no businesses that were matching the filters
      list.add(const Text("No Flagged Businesses!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          )));
      j++;
    }
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses (maybe hardcode for future)
  Map<String, String> category = {};
  Map<String, int> defaultMap = {}; //used if viewing all (from nav. bar)
  int _selectedIndex = 1;

  Scaffold makeFirstScaffold() {
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'For The People: Flagged Businesses',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: Colors.blueGrey,
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
    //builds the UI screen for the button page
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeFirstScaffold();
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
