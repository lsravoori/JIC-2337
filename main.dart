import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
import '../../../firebase_options.dart';
import '../../../business_info.dart';

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
      home: const FirstRoute(title: 'Business List'),
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
  }
}
