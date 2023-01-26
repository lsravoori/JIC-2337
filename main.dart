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
    list.clear();
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    await FirebaseFirestore.instance
        .collection('Businesses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["Category"] == selectedValue ||
            selectedValue == "Filters" ||
            doc["Zipcode"] == selectedValue) {
          list.add(TextButton(
              child: Container(
                color: Colors.pinkAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        }
        category[doc["Category"]] = doc["Category"];
        category[doc["Zipcode"]] = doc["Zipcode"];
      });
    });
    list.add(
      DropdownButton(
          value: selectedValue,
          items: dropdownItems,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          }),
    ); //This creates the dropdown button. Right now it is at the top of the screen
    //It has a selected value and selecting something else changes the value of the button
    //I haven't gotten to adding it filtering yet as I can't get the menu items to work
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses
  //I could hard code this but am trying not to do that
  Map<String, String> category = {
    //'POC': 'POC',
    //'Women': 'Women',
    //'LGBTQ+': 'LGBTQ+'
  };

  //This creates the list of dropdown items by going through all of the values in the hash map
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Add/Remove Filters"), value: "Filters"),
    ];
    category.forEach((key, value) {
      menuItems.add(
        DropdownMenuItem(child: Text(key), value: value),
      );
    });
    return menuItems;
  }

  //This is the value that defaults on the dropdown menu
  String selectedValue = "Filters";

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

  //The only thing I added here is calling getCategories to try and get the categories
  //the first time it is run.
  @override
  Widget build(BuildContext context) {
    //getCategories();
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
