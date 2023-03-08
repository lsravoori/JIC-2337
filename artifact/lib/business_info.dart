import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../login.dart';
import '../../../business_search.dart';
import '../../../home.dart';
import '../../../account_page.dart';

class BusinessInfo extends StatefulWidget {
  const BusinessInfo({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final int number; //number is used for selected index logic for nav bar

  // Below, _BusinessInfoState passes in the string "title" which is the business name
  @override
  State<BusinessInfo> createState() => _BusinessInfoState(title, number);
}

class _BusinessInfoState extends State<BusinessInfo> {
  var business = ""; //name of the business
  Map<String, Object>? businessInfo =
      Map<String, Object>(); //hashmap of the business details
  List<Widget> infoList =
      []; //unused for now, but will be used for creation of the scaffold
  int number = 3;

  _BusinessInfoState(String business, int number) {
    this.business = business;
    getInformation(business);
    this.number = number;
    //this.infoList = createInfoWidgets(businessInfo); //unused for now, will probably delete/repurpose
  }

  Future<QuerySnapshot> getInformation(business) async {
    _selectedIndex = number;
    //gets information of the businesses (by name) and puts into a hashmap
    var retVal = Map<String, Object>(); //temp hashmap for collection

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
    AppBar appBarInfo;
    if (businessInfo?["Verified"] == true) {
      appBarInfo = AppBar(
        title: Row(
          children: <Widget>[
            Text(widget.title),
            Image.asset(
              'assets/images/verified_icon.png',
              height: 25,
              width: 25,
            )
          ]
        ),
        backgroundColor: Colors.blueGrey,
      );
    } else {
      appBarInfo = AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      );
    }
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: appBarInfo,
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
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 2, 2),
                child: Text("Logo: ${businessInfo!['Logo']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Category: ${businessInfo!['Category']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Phone Number: ${businessInfo!['Phone Number']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Hours: ${businessInfo!['Hours']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Address: ${businessInfo!['Street Name']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Zipcode: ${businessInfo!['Zipcode']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Details: ${businessInfo!['Business Details']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 2, 2),
                child: Text("Website: ${businessInfo!['Website']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
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
  Map<String, int> random = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // The line below usually is preceded with the keyword 'await' but this
      // threw errors due to the method not being an async method.
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
            receivedMap: random,
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
