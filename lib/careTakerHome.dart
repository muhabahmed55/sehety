import 'package:flutter/material.dart';
import 'package:sehety/Orders.dart';
import 'package:sehety/Reminder.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/addMedicine.dart';
import 'package:sehety/careTaker.dart';
import 'package:sehety/editInfo.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/makeOrder.dart';
import 'package:sehety/medicalProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sehety/careTaker.dart';

class CareWelcomePage extends StatefulWidget {
  String email;
  String uemail;
  CareWelcomePage({required this.email, required this.uemail});

  @override
  State<CareWelcomePage> createState() => _CareWelcomePageState();
}

class _CareWelcomePageState extends State<CareWelcomePage> {
  List users = [];
  getData() async {
    DocumentReference usersref =
        FirebaseFirestore.instance.collection("users").doc(widget.email);
    var responsebody = await usersref.get();
    setState(() {
      users.add(responsebody.data());
    });
  }

  @override
  void initState() {
    getData();
    print(users);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sehety'),
        backgroundColor: Color(0xFF8692FD),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: users.isEmpty || users == null
                ? Text("Signing in..")
                : Text(
                    "CareTaker: ${users[0]['fname']}",
                    style: TextStyle(
                      fontSize: 30, // Change font size here
                      fontWeight: FontWeight.normal, // Make font bold
                      fontFamily: 'Noto Sans',
                      color: Color(0xFF8692FD), // Change font family here
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: GridView(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MedicalInfo(email: widget.email)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFF8692FD),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_information,
                            size: 100,
                            color: Colors.white,
                          ),
                          Text(
                            "Medical Profile",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Reminder(email: widget.email)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFF8692FD),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_moderator_outlined,
                            size: 100,
                            color: Colors.white,
                          ),
                          Text(
                            "My Medicines",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Orders(email: widget.email)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFF8692FD),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_information,
                            size: 100,
                            color: Colors.white,
                          ),
                          Text(
                            "My Orders",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CareTaker(
                                    email: widget.email,
                                  )));
                    },
                  ),
                ],
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 10),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        width: 140.0,
        height: 60.0,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomePage(email: widget.uemail)),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            primary: Color(0xFFFF7378),
          ),
          child: Text(
            "Your account",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
