import 'package:artifact/admin_business_info.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../admin_business.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AdminScreen> createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> {
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
        .collection('Businesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (defaultMap.isEmpty ||
            defaultMap.containsKey(doc["Category"]) ||
            defaultMap.containsKey(doc["Zipcode"].toString())) {
          //filters based on incoming map
          i++;
          String name = i.toString() + ". ";
          //doc["Business Name"]; //logic for numbering business
          Container businessContainer;
          String hours = "Hours: " + doc["Hours"];
          String phoneNumber = "Phone Number: " + doc["Phone Number"];
          String webSite = "Website: " + doc["Website"];

          if (doc["Verified"]) {
            businessContainer = Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                      child: Text(
                        name,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 25.0),
                      )),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text(
                      doc["Business Name"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const Icon(Icons.check_circle_outline)
                ]),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
                    child: Text(doc["Business Details"])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                    child: Text(hours)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                    child: Text(phoneNumber)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 10),
                    child: Text(webSite))
              ],
            ));
          } else {
            businessContainer = Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                        child: Text(
                          name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 25.0),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 2, 2),
                        child: Text(
                          doc["Business Name"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              decoration: TextDecoration.underline),
                        )),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
                    child: Text(doc["Business Details"])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                    child: Text(hours)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
                    child: Text(phoneNumber)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 2, 2, 10),
                    child: Text(webSite))
              ],
            ));
          }

          list.add(
            Card(
              elevation: 10,
              color: const Color.fromARGB(255, 240, 240, 240),
              child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    //button moves to the business_info page that displays all the details (that code is in business_info.dart)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminBusinessInfo(
                                title: doc.id,
                                number: _selectedIndex,
                              )),
                    );
                  },
                  child: businessContainer),
            ),
          );
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

  int _selectedIndex = 2; //this is the page we are on

  void _onItemTapped(int index) {
    //this is the logic for the bottom navigation bar and which page to flip to
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
          builder: (context) => const AdminBusiness(title: 'admin'),
        ),
      );
    }
  }

  Scaffold makeScaffold() {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text(
          'Administrator View',
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
        //this is the setup for the bottom navigation bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.redAccent,
            ),
            label: 'Logout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Flagged',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'All',
          ),
        ],
        selectedItemColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
      ),
    );
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
