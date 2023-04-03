import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  // Below, _BusinessInfoState passes in the string "title" which is the business id
  @override
  State<BusinessInfo> createState() => _BusinessInfoState(title, number);
}

class _BusinessInfoState extends State<BusinessInfo> {
  var business = ""; //name of the business
  Map<String, Object>? businessInfo =
      <String, Object>{}; //hashmap of the business details
  List<Widget> infoList =
      []; //unused for now, but will be used for creation of the scaffold
  int number = 3;
  double _rating = 0;
  double avgRating = 0;

  _BusinessInfoState(this.business, this.number) {
    getInformation(business);
    //this.infoList = createInfoWidgets(businessInfo); //unused for now, will probably delete/repurpose
  }

  Future<QuerySnapshot> getInformation(business) async {
    _selectedIndex = number;
    //gets information of the businesses (by name) and puts into a hashmap
    var retVal = <String, Object>{}; //temp hashmap for collection

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
    Map<String, dynamic> ratingMap =
        businessInfo!['Ratings'] as Map<String, dynamic>;
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    int count = 0;
    if (_rating == 0) {
      if (ratingMap.containsKey("$uid")) {
        _rating = ratingMap["$uid"]!;
      }
      ratingMap.forEach(((key, value) {
        avgRating = avgRating + value;
        count++;
      }));
      if (count == 0) {
        avgRating = 0;
      } else {
        avgRating = avgRating / count;
      }
    }
    AppBar appBarInfo;
    if (businessInfo?["Verified"] == true) {
      appBarInfo = AppBar(
        title: Row(children: <Widget>[
          Text("${businessInfo!['Business Name']}"),
          const Icon(Icons.check_circle_outline),
          RatingBarIndicator(
            rating: avgRating,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Text(
            "$count reviews",
            style: const TextStyle(fontSize: 10),
          )
        ]),
        backgroundColor: Colors.blueGrey,
      );
    } else {
      appBarInfo = AppBar(
        title: Row(children: <Widget>[
          Text("${businessInfo!['Business Name']}"),
          RatingBarIndicator(
            rating: avgRating,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Text(
            "$count reviews",
            style: const TextStyle(fontSize: 10),
          )
        ]),
        backgroundColor: Colors.blueGrey,
      );
    }
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: appBarInfo,
      body: SingleChildScrollView(
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
                padding: const EdgeInsets.fromLTRB(10, 10, 2, 2),
                child: Text("Logo: ${businessInfo!['Logo']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Details: ${businessInfo!['Business Details']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Category: ${businessInfo!['Category']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Phone Number: ${businessInfo!['Phone Number']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Hours: ${businessInfo!['Hours']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Address: ${businessInfo!['Street Name']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Zipcode: ${businessInfo!['Zipcode']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Website: ${businessInfo!['Website']}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 20))),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 2, 2),
                child: Text("Been Here?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 15))),
            TextButton(
              //creates a button that goes to the next filter page
              child: Container(
                color: Colors.blueGrey,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: const Text(
                  "Review",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: const Text('Review this Business'),
                    actions: <Widget>[
                      RatingBar(
                        initialRating: _rating,
                        minRating: 1,
                        maxRating: 5,
                        allowHalfRating: true,
                        onRatingUpdate: (_rating) => setState(() {
                          this._rating = _rating;
                        }),
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          empty: const Icon(
                            Icons.star,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          CollectionReference busRef = FirebaseFirestore
                              .instance
                              .collection('Businesses');
                          final auth = FirebaseAuth.instance;
                          final User? user = auth.currentUser;
                          final uid = user?.uid;
                          busRef
                              .doc(business)
                              .update({"Ratings.$uid": _rating});
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.end),
              ),
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 2, 2),
                child: Text("See something off?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 12))),
            TextButton(
              child: Container(
                color: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: const Text(
                  "FLAG",
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Submit Flag for Business'),
                  content: const Text('Why are you flagging this business?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        CollectionReference busRef =
                            FirebaseFirestore.instance.collection('Businesses');
                        busRef
                            .doc(business)
                            .update({"Flag Count": FieldValue.increment(1)});
                        busRef.doc(business).update({
                          "Flag Reasons.Inaccurate": FieldValue.increment(1)
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Information Inaccurate'),
                    ),
                    TextButton(
                      onPressed: () async {
                        CollectionReference busRef =
                            FirebaseFirestore.instance.collection('Businesses');
                        busRef
                            .doc(business)
                            .update({"Flag Count": FieldValue.increment(1)});
                        busRef.doc(business).update({
                          "Flag Reasons.Inappropriate": FieldValue.increment(1)
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Information Inappropriate'),
                    ),
                    TextButton(
                      onPressed: () async {
                        CollectionReference busRef =
                            FirebaseFirestore.instance.collection('Businesses');
                        busRef
                            .doc(business)
                            .update({"Flag Count": FieldValue.increment(1)});
                        busRef.doc(business).update(
                            {"Flag Reasons.Other": FieldValue.increment(1)});
                        Navigator.pop(context);
                      },
                      child: const Text('Other'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.redAccent,
            ),
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
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
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
