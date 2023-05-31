import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/addCareTaker.dart';
import 'package:sehety/addMedicine.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sehety/careTakerHome.dart';

class CareTaker extends StatefulWidget {
  String email;
  CareTaker({required this.email});

  @override
  _CareTakerState createState() => _CareTakerState();
}

class _CareTakerState extends State<CareTaker> {
  List careList = [];
  String? deleteCare;

  delete() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users"); // change to "users"

    DocumentReference medRef = usersRef.doc(widget.email);

    CollectionReference medicineRef = medRef.collection('Care Taker');
    medicineRef.doc(deleteCare).delete().then((value) {
      print("Deleted Done");
    });
  } // change to List<Map<String, dynamic>>

  getData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users"); // change to "users"

    DocumentReference medRef = usersRef.doc(widget.email);

    CollectionReference careTakerRef = medRef.collection('Care Taker');
    var responsebody = await careTakerRef.get();
    responsebody.docs.forEach((element) {
      setState(() {
        careList.add(element.data());
      });
      ;
    });
    print(careList);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Care Receivers'),
      ),
      body: ListView.builder(
        itemCount: careList.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CareWelcomePage(
                    email: '${careList[i]['email']}',
                    uemail: widget.email,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blue[100],
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Email: ${careList[i]['email']}"),
                  ),
                  ListTile(
                    title: Text("Relation: ${careList[i]['relation']}"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            deleteCare = careList[i]['name'];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            deleteCare = careList[i]['name'];
                          });
                          delete();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF7378),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddCareTaker(email: widget.email)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
