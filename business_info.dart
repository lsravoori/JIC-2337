import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class BusinessInfo extends StatefulWidget {
  const BusinessInfo({
    super.key,
    required this.title,
  });

  final String title;

  // Below, _BusinessInfoState passes in the string "tempBusinessName". Instead,
  // this should be the identifier of a business, meaning you probably want to pass
  // in the name of the business. If you can find a way to pass in the title parameter
  // from BusinessInfo, then this string could act as the identifier.
  @override
  State<BusinessInfo> createState() => _BusinessInfoState(title);
}

class _BusinessInfoState extends State<BusinessInfo> {
  var business = "";
  Map<String, String>? businessInfo;
  List<Widget> infoList = [];

  _BusinessInfoState(String business) {
    this.business = business;
    getInformation(business);
    //this.infoList = createInfoWidgets(businessInfo);
  }

  Future<QuerySnapshot> getInformation(business) async {
    //This is just a blank and empty Map so IDE does not throw errors.
    var retVal = Map<String, String>();

    // gets a document from the collection if it exists and retrieves its info
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    businesses.doc(business).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        documentFields?.forEach((key, value) {
          retVal.addAll({"$key": documentFields["$key"]});
        });
      }
    });
    businessInfo = retVal;
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  List<Widget> createInfoWidgets(businessInfo) {
    var widgets = <Widget>[];
    var widgetKeys = businessInfo.keys;
    businessInfo.forEach((key, value) {
      widgets.add(Text("$key" ": " "$value"));
    });
    return widgets;
  }

  Scaffold makeSecondScaffold() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 209, 217),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 90, 63, 51),
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
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Phone Number: ${businessInfo!['Phone Number']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Hours: ${businessInfo!['Hours']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Address: ${businessInfo!['Address']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Details: ${businessInfo!['Details']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Text("Website: ${businessInfo!['Website']}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            /*ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 90, 63, 51),
                    foregroundColor: Colors.white),
                child: const Text('Back',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirstRoute(
                              title: 'For the People: All Businesses',
                            )),
                  );
                }),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInformation(business),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeSecondScaffold();
        } else {
          return Scaffold();
        }
      },
    );
  }
}
