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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return MaterialApp(
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
          bool exists = false;
          FirebaseFirestore.instance
              .collection('Accounts')
              .doc(uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              exists = true;
            } else {
              exists = false;
            }
          });
          if (exists) {
            return HomeScreen();
          } else {
            return RegistrationPage();
          }
        }
      },
    );
  }
}
