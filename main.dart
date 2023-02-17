//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forthepeopleartifact/home.dart';
//import 'package:google_fonts/google_fonts.dart';
import '../../../login.dart';
import '../../../home.dart';
//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
//firebase configuration file
import '../../../firebase_options.dart';
//import '../../../business_info.dart';

void main() async {
  //main file that simply starts the application on the login screen
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
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LoginScreen(
          //title: "Home",
          ),
    );
  }
}
