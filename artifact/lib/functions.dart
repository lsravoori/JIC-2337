import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';
import '../../../home.dart';
import '../../../business_search.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  static Color getColor(String category) {
    Color cardColor = Color.fromARGB(255, 240, 240, 240);

    switch (category) {
      case "Women":
        {
          cardColor = Colors.pinkAccent;
        }
        break;
      case "Non-Binary":
        {
          cardColor = Colors.purple;
        }
        break;
      case "LGBT+":
        {
          cardColor = Colors.purple;
        }
        break;
      case "Black":
        {
          cardColor = Colors.redAccent;
        }
        break;
      case "Hispanic":
        {
          cardColor = Colors.yellow;
        }
        break;
      case "Asian":
        {
          cardColor = Colors.blue;
        }
        break;
      case "Pacific Islander":
        {
          cardColor = Colors.blue;
        }
        break;
      case "Native American":
        {
          cardColor = Colors.green;
        }
        break;
      case "Middle Eastern":
        {
          cardColor = Colors.orange;
        }
        break;
    }
    return cardColor;
  }

  static Container getBusinessContainer(String bName, String bDetails,
      String bHours, String bNumber, String bWebsite, bool verified) {
    String name = "";
    Container businessContainer;
    String hours = "Hours: ";
    String phoneNumber = "Phone Number: ";
    String webSite = "Website: ";
    List<Widget> list = [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
          child: Text(
            name,
            style: const TextStyle(color: Colors.black, fontSize: 25.0),
          )),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(bName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold)),
      ),
    ];
    if (verified) {
      list.add(const Icon(Icons.check_circle_outline));
    }
    businessContainer = Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: list),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
            child: Text(
              bDetails,
              style: const TextStyle(color: Colors.white),
            )),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 0, 2),
                child: Text(hours,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Text(bHours, style: const TextStyle(color: Colors.white))
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 0, 2),
                child: Text(phoneNumber,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Text(bNumber, style: const TextStyle(color: Colors.white))
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 0, 2),
                child: Text(webSite,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Text(bWebsite, style: const TextStyle(color: Colors.white))
          ],
        ),
      ],
    ));
    return businessContainer;
  }

  static void onTap(int index, BuildContext context) {
    //logic for nav bar
    Map<String, int> defaultMap = {};
    if (index == 0) {
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
            receivedMap: defaultMap,
          ),
        ),
      );
    }
  }

  static BottomNavigationBar makeNavBar(
      int index, void Function(int) _onItemTapped) {
    return BottomNavigationBar(
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
      currentIndex: index,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
    );
  }
}
