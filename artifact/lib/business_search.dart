import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artifact/login.dart';
//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
import '../../../firebase_options.dart';
import '../../../business_info.dart';

class SearchRoute extends StatefulWidget {
  @override
  State<SearchRoute> createState() => _SearchRoute();
}

class _SearchRoute extends State<SearchRoute> {
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
        if (doc["Category"] ==
                selectedValue || //introduces filters into the businesses pulled with the for loop
            selectedValue == "Filters" ||
            doc["Zipcode"] == selectedValue) {
          i++;
          String name = i.toString() + ". " + doc["Name"];
          list.add(TextButton(
              //creates a button that contains a name of a business in it
              child: Container(
                //color: Colors.pinkAccent,
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
                      builder: (context) => BusinessInfo(title: doc["Name"])),
                );
              }));
          String hours = "Hours: " + doc["Hours"];
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
              child: Text(doc["Details"])));
          list.add(Padding(
              padding: const EdgeInsets.fromLTRB(15, 2, 2, 2),
              child: Text(hours)));

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
        category[doc["Category"]] = doc[
            "Category"]; //populates the filter hashmap with pulled category/zipcode data from the for loop
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
    ); //This creates the dropdown button. Right now it is at the bottom of the screen
    //It has a selected value and selecting something else changes the value of the button
    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ));
    list.add(TextButton(
        //creates a button that contains a name of a business in it
        child: Container(
          color: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ),
        onPressed: () {
          //button moves to the business_info page that displays all the details (that code is in business_info.dart)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }));
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  //This is a hash map that will store all of the categories that are found in the businesses (maybe hardcode for future)
  Map<String, String> category = {};

  //This creates the list of dropdown items by going through all of the values in the hash map
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
       const DropdownMenuItem(
          child: Text("Add/Remove Filters"), value: "Filters"),
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
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text(
          'For The People: Businesses',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor:Colors.blueGrey,
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
