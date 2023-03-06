import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../home.dart';
import '../../../business_info.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            widget.receivedMap.containsKey(doc["Zipcode"])) {
          //filters based on incoming map
          i++;
          String name = i.toString() +
              ". " +
              doc["Business Name"]; //logic for numbering business
          list.add(TextButton(
              //creates a button that contains a name of a business in it
              child: Container(
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
                      builder: (context) => BusinessInfo(
                            title: doc.id,
                            number: _selectedIndex,
                          )),
                );
              }));
          String hours = "Hours: " + doc["Hours"];
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
              child: Text(doc["Business Details"]))); //prints details
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
              child: Text(hours))); //prints hours

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
            color: Colors.blueGrey,
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
                  builder: (context) => HomeScreen(),
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
  Map<String, int> defaultMap = {}; //used if viewing all (from nav. bar)
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    //logic for nav bar
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AccountPage(),
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //nav bar
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
