import 'package:artifact/admin_business_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../login.dart';
import '../../../home.dart';
import '../../../admin_business.dart';
import '../../../admin.dart';
import '../../../business_search.dart';
import '../../../business_info.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  static Card getCard(
      int _selectedIndex, BuildContext context, QueryDocumentSnapshot doc) {
    return Card(
      elevation: 10,
      color: Functions.getColor(doc["Category"]),
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //button moves to the business_info page that displays all the details (that code is in business_info.dart)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BusinessInfo(
                        title: doc.id,
                        number: _selectedIndex,
                      )),
            );
          },
          child: getBusinessContainer(
              doc["Business Name"],
              doc["Business Details"],
              doc["Hours"],
              doc["Phone Number"],
              doc["Website"],
              doc["Verified"])),
    );
  }

  static Card getAdminCard(
      int _selectedIndex, BuildContext context, QueryDocumentSnapshot doc) {
    return Card(
      elevation: 10,
      color: Functions.getColor(doc["Category"]),
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //button moves to the business_info page that displays all the details (that code is in business_info.dart)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminBusinessInfo(
                        title: doc.id,
                        number: _selectedIndex,
                      )),
            );
          },
          child: getBusinessContainer(
              doc["Business Name"],
              doc["Business Details"],
              doc["Hours"],
              doc["Phone Number"],
              doc["Website"],
              doc["Verified"])),
    );
  }

  static Color getColor(String category) {
    Color cardColor = const Color.fromARGB(255, 240, 240, 240);

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
        alignment: Alignment.center,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 2),
            child: Text(
              bDetails,
              style: const TextStyle(color: Colors.white),
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
          builder: (context) => const HomeScreen(),
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

  static void onTapAdmin(int index, BuildContext context) {
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
          builder: (context) => const AdminBusiness(title: 'admin'),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AdminScreen(),
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

  static BottomNavigationBar adminNavBar(
      int _selectedIndex, void Function(int) _onItemTapped) {
    return BottomNavigationBar(
      //this is the setup for the bottom navigation bar
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.redAccent,
          ),
          label: 'Logout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag),
          label: 'Flagged',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'All',
        ),
      ],
      selectedItemColor: Colors.black,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
    );
  }

  static AppBar businessAppBar(double _rating, Map<String, dynamic> ratingMap,
      String uid, double avgRating, Map<String, Object>? businessInfo) {
    int count = 0;
    if (_rating == 0) {
      if (ratingMap.containsKey(uid)) {
        _rating = ratingMap[uid]!;
      }
      ratingMap.forEach(((key, value) {
        avgRating = avgRating + value;
        count++;
      }));
      if (count == 0) {
        avgRating = 0;
      } else {
        avgRating = avgRating / count;
      }
    }
    AppBar appBarInfo;
    if (businessInfo?["Verified"] == true) {
      appBarInfo = AppBar(
        title: Row(children: <Widget>[
          Text("${businessInfo!['Business Name']}"),
          const Icon(Icons.check_circle_outline),
          RatingBarIndicator(
            rating: avgRating,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Text(
            "$count reviews",
            style: const TextStyle(fontSize: 10),
          )
        ]),
        backgroundColor: Functions.getColor("${businessInfo!['Category']}"),
      );
    } else {
      appBarInfo = AppBar(
        title: Row(children: <Widget>[
          Text("${businessInfo!['Business Name']}"),
          RatingBarIndicator(
            rating: avgRating,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Text(
            "$count reviews",
            style: const TextStyle(fontSize: 10),
          )
        ]),
        backgroundColor: Functions.getColor("${businessInfo!['Category']}"),
      );
    }
    return appBarInfo;
  }

  static Widget displayInfo(String text) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 2, 2),
        child: Text(text,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), fontSize: 20)));
  }

  static Widget divider() {
    return const Divider(
      height: 20,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Colors.black,
    );
  }
}
