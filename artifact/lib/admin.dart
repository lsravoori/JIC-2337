import '../../../admin_stats.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../admin_search.dart';
import '../../../admin_flagged.dart';
import '../../../admin_deleted_businesses.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> {
  int _selectedIndex = 1;

  Scaffold makeScaffold() {
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'Administrator View',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: const Color(0xFFD67867),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xFF0D2329),
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminStats(),
                            ));
                      },
                      child: Container(
                        color: const Color(0xFF0D2329),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          "App Statistics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xFF0D2329),
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminFlagged(title: 'admin'),
                            ));
                      },
                      child: Container(
                        color: const Color(0xFF0D2329),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          "Flagged Businesses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 2, 2, 5),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xFF0D2329),
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminDeletedScreen(),
                            ));
                      },
                      child: Container(
                        color: const Color(0xFF0D2329),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          "Deleted Businesses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Functions.adminNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTapAdmin(index, context);
        }));
  }

  @override
  Widget build(BuildContext context) {
    //builds the UI screen
    return makeScaffold();
  }
}
