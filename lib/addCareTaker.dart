import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCareTaker extends StatefulWidget {
  String email;
  AddCareTaker({required this.email});

  @override
  _AddCareTakerState createState() => _AddCareTakerState();
}

class _AddCareTakerState extends State<AddCareTaker> {
  String email = '';
  String _Relation = '';

  void addData() async {
    // Get a reference to the Firestore database
    final databaseReference = FirebaseFirestore.instance;

    // Create a new document reference in the 'users' collection for the user 'john'
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    // Set the data to be added to the 'medicine' collection
    Map<String, dynamic> careData = {
      'email': email,
      'relation': _Relation,
    };

    // Add the medicine data to the 'medicine' collection inside the 'john' document
    await documentReference.collection('Care Taker').doc(email).set(careData);

    print('Medicine data added to Firestore.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Add Care taker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add text fields for user input
              TextField(
                decoration: InputDecoration(
                  labelText: 'CareTaker Email',
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Relation',
                ),
                onChanged: (value) {
                  setState(() {
                    _Relation = value;
                  });
                },
              ),

              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  addData();
                },
                child: Text(style: TextStyle(fontSize: 20), 'Add'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  fixedSize: const Size(300, 50),
                  primary: Colors.white,
                  backgroundColor: Color(0xFF8692FD),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
