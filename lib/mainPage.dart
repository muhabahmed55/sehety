import 'dart:async';

import 'package:flutter/material.dart';
import 'loginPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sehety'),
        backgroundColor: Color(0xFF8692FD),
      ),
      body: Center(
        child: Image(
          image: AssetImage('images/sehety.png'),
          width: 300,
          height: 900,
        ),
      ),
    ));
  }
}
