import 'package:flutter/material.dart';
import 'package:sehety/Reminder.dart';
import 'package:sehety/addMedicine.dart';
import 'package:sehety/makeOrder.dart';
import 'package:sehety/medicalProfile.dart';
import 'Signup.dart';
import 'mainPage.dart';
import 'loginPage.dart';
import 'WelcomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'insertContactInfo.dart';
import '';
import 'package:timezone/data/latest.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:sehety/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/mainPage',
      routes: {
        '/mainPage': (context) => MainPage(),
        '/loginPage': (context) => LoginPage(),
        '/signupPage': (context) => SignUpPage(),
      },
    );
  }
}
