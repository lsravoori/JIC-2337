import 'package:artifact/RegistrationPage.dart';
import 'package:artifact/business_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//firebase core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
//firebase configuration file
import '../../../firebase_options.dart';
import '../../../business_info.dart';
import '../../../business_search.dart';
import '../../../login.dart';
import '../../../home.dart';
import '../../../admin.dart';

void main() async {
  //main file that simply starts the application on the login screen
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    //const PhoneProviderConfiguration(),
    //const GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID),
    //const AppleProviderConfiguration(),
    //const FacebookProviderConfiguration(clientId: FACEBOOK_CLIENT_ID),
    //const TwitterProviderConfiguration(
    //apiKey: TWITTER_API_KEY,
    //apiSecretKey: TWITTER_API_SECRET_KEY,
    //redirectUri: TWITTER_REDIRECT_URI,
    //),
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool exists = false;
  Map<String, Object>? previousInfo = Map<String, Object>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Montserrat'),
      title: 'We The People',
      initialRoute: auth.currentUser == null ? 'landing' : '/profile',
      routes: {
        'landing': (context) {
          return LoginScreen();
        },
        '/': (context) {
          return SignInScreen(
            // no providerConfigs property - global configuration will be used instead
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, 'search');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            // no providerConfigs property here as well
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
          );
        },
        'search': (context) {
          final User? user = auth.currentUser;
          final uid = user?.uid;
          return FutureBuilder(
            future: testUID(uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (exists) {
                  bool isAdmin = previousInfo!['isAdmin'] as bool;
                  if (isAdmin) {
                    return AdminScreen();
                  } else {
                    return HomeScreen();
                  }
                } else {
                  return RegistrationPage();
                }
              } else {
                return const Scaffold();
              }
            },
          );
        }
      },
    );
  }

  Future<QuerySnapshot> testUID(uid) async {
    var retVal = Map<String, Object>(); //temp hashmap for collection
    await FirebaseFirestore.instance
        .collection('Accounts')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        exists = true;
        //checks if the user with the given name exists
        Map<String, dynamic>? documentFields =
            documentSnapshot.data() as Map<String, dynamic>?;
        documentFields?.forEach((key, value) {
          //collects the data from a hashmap and moves to temp hashmap (inefficient, make better later)
          retVal.addAll({"$key": documentFields["$key"]});
        });
      } else {
        exists = false;
      }
    });
    previousInfo = retVal; //sets previousInfo equal to temp hashmap
    return await FirebaseFirestore.instance.collection('Accounts').get();
    ;
  }
}
