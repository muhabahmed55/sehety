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

class WelcomePage extends StatefulWidget {
  String email;

  WelcomePage({required this.email});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: users.isEmpty || users == null
                  ? Text("Signing in..")
                  : Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Hii ${users[0]['fname']}",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14110F)),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome to SEHETY.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF14110F),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Our services:",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MedicalInfo(email: widget.email)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFF8692FD),
                            width: 4.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_information,
                              size: 80,
                              color: Color(0xFF8692FD),
                            ),
                            Text(
                              "Medical Profile",
                              style: TextStyle(
                                  color: Color(0xFF8692FD), fontSize: 22),
                            ),
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
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xFF8692FD),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_moderator_outlined,
                              size: 80,
                              color: Colors.white,
                            ),
                            Text(
                              "My Medicines",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
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
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xFF8692FD),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              size: 80,
                              color: Colors.white,
                            ),
                            Text(
                              "My Orders",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
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
                                  CareTaker(email: widget.email)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFF8692FD),
                            width: 4.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 80,
                              color: Color(0xFF8692FD),
                            ),
                            Text(
                              "Care Receiver",
                              style: TextStyle(
                                  color: Color(0xFF8692FD), fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
