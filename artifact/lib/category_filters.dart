import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../business_search.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.receivedMap});
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
  State<CategoryScreen> createState() => _CategoryScreen(receivedMap);
}

class _CategoryScreen extends State<CategoryScreen> {
  _CategoryScreen(Map<String, int> recievedMap);

  List<Widget> list =
      []; //this is a list of children for the scaffold that shows up on screen (right column)
  List<Widget> list2 = []; //list of children (left column)
  List<bool> checked = <bool>[]; //used for checkbox logic
  List<String> cats = [
    "Women",
    "Non-Binary",
    "LGBT+",
    "Black",
    "Hispanic",
    "Asian",
    "Pacific Islander",
    "Native American",
    "Middle Eastern"
  ]; //list of "categories"

  createCheckBox() {
    //creates checkboxes with two seperate columns
    list.clear();
    list2.clear();
    for (int i = 0; i < cats.length; i++) {
      checked.add(false);
      if (i < 3) {
        list.add(SizedBox(
            width: 150,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text(cats[i]),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      widget.receivedMap[cats[i]] = i;
                    }
                  });
                })));
      } else {
        list2.add(SizedBox(
            width: 150,
            child: CheckboxListTile(
                value: checked[i],
                checkColor: Colors.white,
                title: Text(cats[i]),
                onChanged: (bool? values) {
                  setState(() {
                    checked[i] = values!;
                    if (values = true) {
                      widget.receivedMap[cats[i]] = i;
                    }
                  });
                })));
      }
    }
    //the button below navigates to the business search page
    list2.add(SizedBox(
        width: 150,
        child: TextButton(
            //creates a button that contains a name of a business in it
            child: Container(
              color: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                "Submit",
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
            })));
  }

  Map<String, int> defaultMap = {}; //used if viewing all (from nav. bar)
  Map<String, int> returnMap = {}; //used if want to pass on filter info

  int _selectedIndex = 1; //current page we are on

  void _onItemTapped(int index) {
    //navigation bar logic and which page to go to
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
            receivedMap: defaultMap,
          ),
        ),
      );
    }
  }

  Scaffold makeFirstScaffold() {
    createCheckBox();
    //this creates the scaffold using the children list mentioned above (separate method to make build() smaller)
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text(
          'For The People: Types of Businesses',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
          //allows scrolling
          child: Row(
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
      )),
      bottomNavigationBar: BottomNavigationBar(
        //navigation bar
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
