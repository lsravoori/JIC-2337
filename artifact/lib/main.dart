import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artifact/login.dart';
//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
import '../../../firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We The People',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<FirstRoute> createState() => _FirstRoute();
}

class _FirstRoute extends State<FirstRoute> {
  //const FirstRoute({super.key});
  List<Widget> list = [];

  Future<QuerySnapshot> getData() async {
    await FirebaseFirestore.instance
        .collection('Businesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list.add(TextButton(
            child: Container(
              color: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                doc["Name"],
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BusinessInfo(title: doc["Name"])),
              );
            }));
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
      });
    });
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  Scaffold makeFirstScaffold() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 209, 217),
      appBar: AppBar(
        title: const Text(
          'For The People: All Businesses',
          style: TextStyle(color: Colors.white, fontSize: 40.0),
        ),
        backgroundColor: Color.fromARGB(255, 90, 63, 51),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeFirstScaffold();
        } else {
          return Scaffold();
        }
      },
    );

    /*Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 209, 217),
      appBar: AppBar(
        title: const Text(
          'For The People: All Businesses',
          style: TextStyle(color: Colors.white, fontSize: 40.0),
        ),
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
            children: list
            /*const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),
              //What I want here is a for loop where text buttons are created for each data entry
              TextButton(
                  child: Container(
                    color: Colors.pinkAccent,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      'Another Store',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BusinessInfo(title: 'Another Store')),
                    );
                  }),
              const Divider(
                height: 20,
                thickness: 3,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
            ]
            TextButton(
                child: Container(
                  color: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    "John's Bakery",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BusinessInfo(title: "John's Bakery")),
                  );
                }),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),*/

            ),
      ),
    );*/
  }
}

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

    // NEEDS TO BE IMPLEMENTED. When a business is passed in, the data from Firebase should be gathered and put into a Map<String, String>.
    // The key will be something like "Business Name" or "Hours of Operation", and the value should be something like "Target" or "9 a.m. - 5 p.m.".
    // This map will then be used to create Text Widgets displaying the information. Try to add the keys/values in the same order for each business,
    // This will help prevent issues with the Business name appearing halfway down the list. We would not want the screen to display the address,
    // followed by the hours of operation, the Business Name, and then the phone number. Decide on an ordering in which information should be
    // Displayed.
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
            ElevatedButton(
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
                }),
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
