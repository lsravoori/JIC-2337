import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../category_filters.dart';
import '../../../business_search.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    "30332",
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
    for (int i = 0; i < zips.length; i++) {
      checked.add(false);
      if (i <= zips.length / 2) {
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
    //the button below is used to navigate to the next page
    list.add(SizedBox(
        width: 150,
        child: TextButton(
            //creates a button that goes to the next filter page
            child: Container(
              color: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: const Text(
                "Next",
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
            })));
  }

  Map<String, int> defaultMap =
      {}; //this is used if we want to go to business search without any entries
  Map<String, int> returnMap =
      {}; //this is used if we want to go to business search with filters

  int _selectedIndex = 1; //this is the page we are on

  void _onItemTapped(int index) {
    //this is the logic for the bottom navigation bar and which page to flip to
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
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
          'For The People: Possible ZipCodes',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          //this allows us to scroll
          child: Row(
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
      )),
      bottomNavigationBar: BottomNavigationBar(
        //this is the setup for the bottom navigation bar
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
