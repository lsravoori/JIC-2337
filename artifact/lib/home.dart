import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../category_filters.dart';
import '../../../business_search.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen
  List<Widget> list2 = []; //this is the list for the second column
  List<bool> checked = <bool>[]; //this is the checkbox values
  List<String> zips = [
    "30341",
    "30340",
    "30345",
    "30319",
    "30329",
    "30342",
    "30326",
    "30324",
    "30327",
    "30305",
    "30309",
    "30318",
    "30339",
    //"30332",
    "30080",
    "30363",
    "30313",
    "30314",
    "30310",
    "30303",
    "30308",
    "30311",
    "30310",
    "30312",
    "30334",
    "30315",
    "30337",
    "30354",
    "30315",
    "30316",
    "30306",
    "30307",
    "30317",
    "30032",
    "30030",
    "30002",
    "30079",
    "30033",
    "30084"
  ]; //this is a list of Atlanta zipcodes

  createCheckBox() {
    //this methods creates the checkboxes and adds them to two seperate lists (one for each column)
    list.clear();
    list2.clear();
    zips.sort((a, b) {
      //sorting in ascending order
      return a.compareTo(b);
    });
    for (int i = 0; i < zips.length; i++) {
      checked.add(false);
      if (i < zips.length / 2) {
        list.add(SizedBox(
            width: 150,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text(zips[i]),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      returnMap[zips[i]] = i;
                    }
                  });
                })));
      } else {
        list2.add(SizedBox(
            width: 150,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text(zips[i]),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      returnMap[zips[i]] = i;
                    }
                  });
                })));
      }
    }
  }

  Map<String, int> defaultMap =
      {}; //this is used if we want to go to business search without any entries
  Map<String, int> returnMap =
      {}; //this is used if we want to go to business search with filters

  int _selectedIndex = 1; //this is the page we are on

  Scaffold makeFirstScaffold() {
    createCheckBox();
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'For The People: Possible ZipCodes',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: const Color(0xFFD67867),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          //this allows us to scroll
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list2),
                ],
              ),
              SizedBox(
                  child: TextButton(
                      //creates a button that goes to the next filter page
                      child: Container(
                        color: const Color(0xFFD67867),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          "Next: Select Business Type",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                      onPressed: () {
                        //button moves to the category filter page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategoryScreen(receivedMap: returnMap)),
                        );
                      })),
              const Padding(padding: EdgeInsets.all(20)),
            ],
          ),
        ),
        bottomNavigationBar: Functions.makeNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTap(index, context);
        }));
  }

  @override
  Widget build(BuildContext context) {
    //builds the UI screen for the button page
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return makeFirstScaffold();
        },
      ),
    );
  }
}
