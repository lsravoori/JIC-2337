import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../business_search.dart';
import '../../../account_page.dart';
import '../../../functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.receivedMap});
  final Map<String, int> receivedMap;
  //the recievedMap is the entries from the previous filter page

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<VerificationScreen> createState() => _VerificationScreen(receivedMap);
}

class _VerificationScreen extends State<VerificationScreen> {
  _VerificationScreen(Map<String, int> recievedMap);

  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen (right column)
  List<Widget> list2 = []; //list of children (left column)
  List<bool> checked = <bool>[]; //used for checkbox logic
  List<String> verif = [
    "false",
    "true"
  ]; //list to check if the target is verified or not

  createCheckBox() {
    //creates checkboxes with two seperate columns
    list.clear();
    list2.clear();
    for (int i = 0; i < verif.length; i++) {
      checked.add(false);
      if (i < 1) {
        list.add(SizedBox(
            width: 200,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text("Unverified Businesses"),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      widget.receivedMap[verif[i]] = i;
                    }
                  });
                })));
      } else {
        list2.add(SizedBox(
            width: 200,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text("Verified Businesses"),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      widget.receivedMap[verif[i]] = i;
                    }
                  });
                })));
      }
    }
  }

  Map<String, int> defaultMap = {}; //used if viewing all (from nav. bar)
  Map<String, int> returnMap = {}; //used if want to pass on filter info

  int _selectedIndex = 1; //current page we are on

  Scaffold makeFirstScaffold() {
    createCheckBox();
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'For The People: Verified Businesses',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: const Color(0xFFD67867),
        ),
        body: SingleChildScrollView(
            //allows scrolling
            child: Column(
          children: [
            Text(
              'Would you like to search for Unverified Businesses, Verified Businesses, or Both?\n',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list2),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list),
              ],
            ),
            SizedBox(
                child: TextButton(
                    //creates a button that contains a name of a business in it
                    child: Container(
                      color: const Color(0xFFD67867),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: const Text(
                        "Submit Filters",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                    onPressed: () {
                      if (widget.receivedMap.isEmpty) {
                        widget.receivedMap["empty"] = 2;
                      }
                      //button moves to the business_info page that displays all the details (that code is in business_info.dart)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirstRoute(
                                  title: 'IDK',
                                  receivedMap: widget.receivedMap,
                                )),
                      );
                    })),
            const Padding(padding: EdgeInsets.all(20)),
          ],
        )),
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
