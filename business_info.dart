import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:forthepeopleartifact/home.dart';
//import '../../../firebase_options.dart';
import '../../../login.dart';
import '../../../business_search.dart';
//import 'package:firebase_core/firebase_core.dart';

class BusinessInfo extends StatefulWidget {
  const BusinessInfo({
    super.key,
    required this.title,
  });

  final String title;

  // Below, _BusinessInfoState passes in the string "title" which is the business name
  @override
  State<BusinessInfo> createState() => _BusinessInfoState(title);
}

class _BusinessInfoState extends State<BusinessInfo> {
  var business = ""; //name of the business
  Map<String, String>? businessInfo =
      Map<String, String>(); //hashmap of the business details
  List<Widget> infoList =
      []; //unused for now, but will be used for creation of the scaffold

  _BusinessInfoState(String business) {
    this.business = business;
    getInformation(business);
    //this.infoList = createInfoWidgets(businessInfo); //unused for now, will probably delete/repurpose
  }

  Future<QuerySnapshot> getInformation(business) async {
    //gets information of the businesses (by name) and puts into a hashmap
    var retVal = Map<String, String>(); //temp hashmap for collection

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
          retVal.addAll({"$key": documentFields["$key"]});
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
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Logo: ${businessInfo!['Logo']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Category: ${businessInfo!['Category']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Phone Number: ${businessInfo!['Phone Number']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Hours: ${businessInfo!['Hours']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Address: ${businessInfo!['Address']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Zipcode: ${businessInfo!['Zipcode']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Details: ${businessInfo!['Details']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Website: ${businessInfo!['Website']}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
          ],
        ),
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
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const FirstRoute(
            title: 'Search',
          ),
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
