import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:forthepeopleartifact/business_search.dart';
//import 'package:google_fonts/google_fonts.dart';
import '../../../login.dart';
//firebase core plugin
//import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
//import '../../../firebase_options.dart';
import '../../../business_info.dart';
import '../../../business_search.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  //const FirstRoute({super.key});
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen

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
        category[doc["Category"]] =
            i; //populates the filter hashmap with pulled category/zipcode data from the for loop
        i++;
        zipcode[doc["Zipcode"]] = i;
        i++;
        checked.add(false);
        checked.add(false);
        // list.add(CheckboxListTile(
        //     value: checked[0],
        //     checkColor: Colors.white,
        //     title: Text(doc["Category"]),
        //     onChanged: (bool? value) {
        //       setState(() {
        //         checked[0] = value!;
        //       });
        //     }));
        // String zipcode = "Zipcode: " + doc["Zipcode"];
        // checked.add(false);
        // list.add(CheckboxListTile(
        //     value: checked[1],
        //     checkColor: Colors.white,
        //     title: Text(zipcode),
        //     onChanged: (bool? value) {
        //       setState(() {
        //         checked[1] = value!;
        //       });
        //     }));
      });
    });
    category.forEach((key, value) {
      if (checked[value]) {
        returnMap[key] = value;
      }
      list.add(
        CheckboxListTile(
            value: checked[value],
            checkColor: Colors.white,
            title: Text(key),
            onChanged: (bool? values) {
              setState(() {
                checked[value] = values!;
              });
            }),
      );
    });
    zipcode.forEach((key, value) {
      if (checked[value]) {
        returnMap[key] = value;
      }
      list.add(
        CheckboxListTile(
            value: checked[value],
            checkColor: Colors.white,
            title: Text("Zipcode: " + key),
            onChanged: (bool? values) {
              setState(() {
                checked[value] = values!;
              });
            }),
      );
    });
    // list.add(CheckboxListTile(
    //         value: checked[1],
    //         checkColor: Colors.white,
    //         title: Text(category.),
    //         onChanged: (bool? value) {
    //           setState(() {
    //             checked[1] = value!;
    //           });
    //         }));
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    list.add(TextButton(
        //creates a button that contains a name of a business in it
        child: Container(
          color: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: const Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
        onPressed: () {
          //button moves to the business_info page that displays all the details (that code is in business_info.dart)
          for (int i = 0; i < checked.length; i++) {
            checked[i] = false;
          }
          i = 0;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FirstRoute(
                      title: 'IDK',
                      receivedMap: returnMap,
                    )),
          );
        }));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  List<bool> checked = <bool>[];
  Map<String, int> category = {};
  Map<String, int> zipcode = {};
  Map<String, int> returnMap = {};
  Map<String, int> defaultMap = {};
  String info = "";

  Scaffold makeFirstScaffold() {
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text(
          'For The People: Home',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
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

  int _selectedIndex = 1;

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
