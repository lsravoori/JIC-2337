import 'package:artifact/admin_business_info.dart';
import 'package:artifact/admin_deleted_businesses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../login.dart';
import '../../../home.dart';
import '../../../admin_business.dart';
import '../../../admin.dart';
import '../../../business_search.dart';
import '../../../business_info.dart';
import '../../../account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
          cardColor = const Color.fromARGB(255, 225, 119, 155);
        }
        break;
      case "Non-Binary":
        {
          cardColor = const Color.fromARGB(255, 189, 67, 211);
        }
        break;
      case "LGBT+":
        {
          cardColor = const Color.fromARGB(255, 189, 67, 211);
        }
        break;
      case "Black":
        {
          cardColor = const Color.fromARGB(255, 248, 23, 7);
        }
        break;
      case "Hispanic":
        {
          cardColor = const Color.fromARGB(255, 181, 165, 14);
        }
        break;
      case "Asian":
        {
          cardColor = const Color.fromARGB(255, 82, 145, 196);
        }
        break;
      case "Pacific Islander":
        {
          cardColor = const Color.fromARGB(255, 82, 145, 196);
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
      default:
        {
          cardColor = Colors.black;
        }
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
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AdminDeletedScreen(),
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
        BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Deleted')
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

  static Future displayImage(String filePath) async {
    if (filePath != "") {
      Uint8List? imageBytes = await FirebaseStorage.instance
          .ref()
          .child(filePath)
          .getData(10000000);
      if (imageBytes != null) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 2, 2),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
            ));
      }
    }
    return;
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

  static Widget adminInfoButtons(BuildContext context, String business,
      Map<String, Object>? businessInfo, bool deleted) {
    if (!deleted) {
      return TextButton(
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: const Text(
            "Remove Business",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure you want to remove this business?'),
            content: const Text('This can be undone in deleted page.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Remove');
                  deleteBusiness(business, businessInfo);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                },
                child: const Text('REMOVE'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    } else {
      return TextButton(
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: const Text(
            "Add Business",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are you sure you want to re-add this business?'),
            content: const Text('This cannot be undone.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Remove');
                  readdBusiness(business, businessInfo);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                },
                child: const Text('ADD'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    }
  }

  static Widget adminRemoveFlags(BuildContext context, String business,
      Map<String, Object>? businessInfo, bool deleted) {
    if (!deleted) {
      return TextButton(
        child: Container(
            color: Colors.lightGreenAccent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: const Text(
              "Clear Flags",
              style: TextStyle(fontSize: 10.0),
            )),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
                'Are you sure you want to clear the flags for this business?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  CollectionReference busRef =
                      FirebaseFirestore.instance.collection('Businesses');
                  busRef.doc(business).update({"Flag Count": 0});
                  busRef.doc(business).update({"Flag Reasons.Inaccurate": 0});
                  busRef
                      .doc(business)
                      .update({"Flag Reasons.Inappropriate": 0});
                  busRef.doc(business).update({"Flag Reasons.Other": 0});
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Padding(padding: EdgeInsets.all(2));
    }
  }

  static void deleteBusiness(
      String business, Map<String, Object>? businessInfo) {
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    CollectionReference delBusinesses =
        FirebaseFirestore.instance.collection('DeletedBusinesses');
    CollectionReference users =
        FirebaseFirestore.instance.collection('Accounts');
    businesses.doc(business).get().then((DocumentSnapshot documentSnapshot) {
      //creates a snapshot for the business by name
      if (documentSnapshot.exists) {
        //checks if the business with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (documentFields != null) {
          //Find out the userID below and remove businessID from their list of businesses.
          if (documentFields.keys.toList().contains("UserID")) {
            String userID = documentFields["UserID"];
            users.doc(userID).get().then((DocumentSnapshot userSnapshot) {
              if (userSnapshot.exists) {
                Map<String, dynamic>? userFields =
                    userSnapshot.data() as Map<String, dynamic>?;
                if (userFields != null) {
                  if (userFields.keys.toList().contains("BusinessIDs")) {
                    List businessIDS = userFields["BusinessIDs"];
                    businessIDS.remove(documentSnapshot.id);
                    FirebaseFirestore.instance
                        .collection('Accounts')
                        .doc(userID)
                        .update({'BusinessIDs': businessIDS});
                  }
                }
              }
            });
          }
          //Copy business document from the 'Businesses' collection to the 'DeletedBusinesses' collection
          delBusinesses
              .doc(business)
              .get()
              .then((DocumentSnapshot delDocSnapshot) {
            FirebaseFirestore.instance
                .collection('DeletedBusinesses')
                .doc(documentSnapshot.id)
                .set(documentFields);
          });
        }
        businesses.doc(business).delete();
      }
    });
  }

  static void readdBusiness(
      String business, Map<String, Object>? businessInfo) {
    CollectionReference businesses =
        FirebaseFirestore.instance.collection('Businesses');
    CollectionReference delBusinesses =
        FirebaseFirestore.instance.collection('DeletedBusinesses');
    CollectionReference users =
        FirebaseFirestore.instance.collection('Accounts');
    delBusinesses.doc(business).get().then((DocumentSnapshot documentSnapshot) {
      //creates a snapshot for the business by name
      if (documentSnapshot.exists) {
        //checks if the business with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (documentFields != null) {
          //Find out the userID below and remove businessID from their list of businesses.
          if (documentFields.keys.toList().contains("UserID")) {
            String userID = documentFields["UserID"];
            users.doc(userID).get().then((DocumentSnapshot userSnapshot) {
              if (userSnapshot.exists) {
                Map<String, dynamic>? userFields =
                    userSnapshot.data() as Map<String, dynamic>?;
                if (userFields != null) {
                  if (userFields.keys.toList().contains("BusinessIDs")) {
                    List businessIDS = userFields["BusinessIDs"];
                    businessIDS.add(documentSnapshot.id);
                    FirebaseFirestore.instance
                        .collection('Accounts')
                        .doc(userID)
                        .update({'BusinessIDs': businessIDS});
                  }
                }
              }
            });
          }
          //Copy business document from the 'Businesses' collection to the 'DeletedBusinesses' collection
          businesses
              .doc(business)
              .get()
              .then((DocumentSnapshot delDocSnapshot) {
            FirebaseFirestore.instance
                .collection('Businesses')
                .doc(documentSnapshot.id)
                .set(documentFields);
          });
        }
        delBusinesses.doc(business).delete();
      }
    });
  }
}
