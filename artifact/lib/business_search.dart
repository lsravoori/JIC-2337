import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../home.dart';
//import 'package:google_fonts/google_fonts.dart';
import '../../../login.dart';
//firebase core plugin
//import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
//import '../../../firebase_options.dart';
import '../../../business_info.dart';

class FirstRoute extends StatefulWidget {
  FirstRoute({super.key, required this.title, required this.receivedMap});
  final Map<String, int> receivedMap;

  //FirstRoute({this.receivedMap});

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
  //const FirstRoute({super.key});

  List<Widget> list = [];

  _FirstRoute(
      Map<String, int>
          recievedMap); //this is a list of children for the scaffold that shows up on screen

  Future<QuerySnapshot> getData() async {
    //getData brings in all of the business from the database based on filters
    int i = 0;
    list.clear();
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    await FirebaseFirestore
        .instance //this whole section pulls business names in with a for each loop
        .collection('Businesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // if (doc["Category"] ==
        //         selectedValue || //introduces filters into the businesses pulled with the for loop
        //     selectedValue == "Filters" ||
        //     doc["Zipcode"] == selectedValue ||
        //     widget.receivedMap.isEmpty) {
        if (widget.receivedMap.isEmpty ||
            widget.receivedMap.containsKey(doc["Category"]) ||
            widget.receivedMap.containsKey(doc["Zipcode"])) {
          i++;
          String name = i.toString() + ". " + doc["Name"];
          list.add(TextButton(
              //creates a button that contains a name of a business in it
              child: Container(
                //color: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      decoration: TextDecoration.underline),
                ),
              ),
              onPressed: () {
                //button moves to the business_info page that displays all the details (that code is in business_info.dart)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusinessInfo(title: doc["Name"])),
                );
              }));
          String hours = "Hours: " + doc["Hours"];
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
              child: Text(doc["Details"])));
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
              child: Text(hours)));

          list.add(const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          ));
          list.add(const Divider(
            height: 20,
            thickness: 3,
            indent: 0,
            endIndent: 0,
            color: Colors.black,
          )); //Divider
        }
        // category[doc["Category"]] = doc[
        //     "Category"]; //populates the filter hashmap with pulled category/zipcode data from the for loop
        // category[doc["Zipcode"]] = doc["Zipcode"];
      });
    });
    // list.add(
    //   DropdownButton(
    //       value: selectedValue,
    //       items: dropdownItems,
    //       onChanged: (String? newValue) {
    //         setState(() {
    //           selectedValue = newValue!;
    //         });
    //       }),
    // ); //This creates the dropdown button. Right now it is at the bottom of the screen
    //It has a selected value and selecting something else changes the value of the button
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses (maybe hardcode for future)
  Map<String, String> category = {};

  //This creates the list of dropdown items by going through all of the values in the hash map
  // List<DropdownMenuItem<String>> get dropdownItems {
  //   List<DropdownMenuItem<String>> menuItems = [
  //     const DropdownMenuItem(
  //         child: Text("Add/Remove Filters"), value: "Filters"),
  //   ];
  //   category.forEach((key, value) {
  //     menuItems.add(
  //       DropdownMenuItem(child: Text(key), value: value),
  //     );
  //   });
  //   return menuItems;
  // }

  //This is the value that defaults on the dropdown menu
  //String selectedValue = "Filters";

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            title: 'Home',
          ),
        ),
      );
    }
  }

  Scaffold makeFirstScaffold() {
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text(
          'For The People: Businesses',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
        //automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list),
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
