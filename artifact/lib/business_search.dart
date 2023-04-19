import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../home.dart';
import '../../../functions.dart';

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key, required this.title, required this.receivedMap});
  final Map<String, int> receivedMap;

  //this map pulls in filter information

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<FirstRoute> createState() => _FirstRoute(receivedMap);
}

class _FirstRoute extends State<FirstRoute> {
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen

  _FirstRoute(Map<String, int> recievedMap); //makes instance of the map

  Future<QuerySnapshot> getData() async {
    //getData brings in all of the business from the database based on filters
    if (widget.receivedMap.isNotEmpty) {
      _selectedIndex = 1;
    }
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
      querySnapshot.docs.forEach((doc) {
        if (widget.receivedMap.isEmpty ||
            widget.receivedMap.containsKey(doc["Category"]) ||
            widget.receivedMap.containsKey(doc["Zipcode"].toString())
        //|| widget.receivedMap.containsKey(doc["Verified"].toString())
        ) {
          //filters based on incoming map
          i++;

          list.add(Functions.getCard(_selectedIndex, context, doc));
          list.add(const Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
          ));
        }
      });
    });
    if (i == 0 && j == 0) {
      //done if there is no businesses that were matching the filters
      list.add(const Text("No Businesses with those filters available!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          )));
      j++;
      list.add(const Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 20)));
      list.add(TextButton(
          child: Container(
            color: const Color(0xFFD67867),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: const Text(
              "Back to Filters",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
          onPressed: () {
            //button moves to the first filter page
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          }));
    }
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses (maybe hardcode for future)
  Map<String, String> category = {};
  int _selectedIndex = 3;

  Scaffold makeFirstScaffold() {
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'For The People: Businesses',
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
        bottomNavigationBar: Functions.makeNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTap(index, context);
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
