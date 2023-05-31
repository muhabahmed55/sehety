import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/addMedicine.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sehety/addMedicine/step1.dart';

class Reminder extends StatefulWidget {
  String email;
  Reminder({required this.email});

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  String? deleteMed;
  List medicineList = []; // change to List<Map<String, dynamic>>

  getData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users"); // change to "users"

    DocumentReference medRef = usersRef.doc(widget.email);

    CollectionReference medicineRef = medRef.collection('Medicine');
    var responsebody = await medicineRef.get();
    responsebody.docs.forEach((element) {
      setState(() {
        medicineList.add(element.data());
      });
      ;
    });
    print(medicineList);
  }

  delete() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users"); // change to "users"

    DocumentReference medRef = usersRef.doc(widget.email);

    CollectionReference medicineRef = medRef.collection('Medicine');
    medicineRef.doc(deleteMed).delete().then((value) {
      print("Deleted Done");
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Reminder'),
      ),
      body: ListView.builder(
        itemCount: medicineList.length,
        itemBuilder: (context, i) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            color: Colors.blue[100],
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                  title: Text("Name: ${medicineList[i]['name']}"),
                ),
                ListTile(
                  title: Text("Dosage: ${medicineList[i]['quantity']}"),
                ),
                ListTile(
                  title: Text("Time: ${medicineList[i]['time']}"),
                ),
                ListTile(
                  title: Text("Note: ${medicineList[i]['note']}"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          deleteMed = medicineList[i]['name'];
                        });
                        print(deleteMed);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deleteMed = medicineList[i]['name'];
                        });
                        delete();
                      },
                    ),
                  ],
                ),
              ],
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
                builder: (context) => AddMedicineStep1(email: widget.email)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
