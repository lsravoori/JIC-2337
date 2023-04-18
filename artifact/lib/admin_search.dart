import 'package:flutter/material.dart';
import '../../../functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Generates "Search All" page for Admins
class AdminSearchScreen extends StatefulWidget {
  const AdminSearchScreen({super.key});
  @override
  State<AdminSearchScreen> createState() => _AdminSearchScreen();
}

class _AdminSearchScreen extends State<AdminSearchScreen> {
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen

  _AdminSearchScreen(); //makes instance of the map

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
          i++;
          list.add(Functions.getAdminCard(_selectedIndex, context, doc));
          list.add(const Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
          )); //Divider
      }
    });
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses (maybe hardcode for future)
  Map<String, String> category = {};
  Map<String, int> defaultMap = {}; //used if viewing all (from nav. bar)
  int _selectedIndex = 2;

  Scaffold makeScaffold() {
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'All Businesses',
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
