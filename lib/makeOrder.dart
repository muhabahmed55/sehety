import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakeOrder extends StatefulWidget {
  String email;
  MakeOrder({required this.email});

  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  // Define variables to store user input
  String medName = '';
  int _medQuantity = 0;

  void addData() async {
    // Get a reference to the Firestore database
    final databaseReference = FirebaseFirestore.instance;

    // Create a new document reference in the 'users' collection for the user 'john'
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    // Set the data to be added to the 'medicine' collection
    Map<String, dynamic> careData = {
      'name': medName,
      'quantity': _medQuantity,
    };

    // Add the medicine data to the 'medicine' collection inside the 'john' document
    await documentReference.collection('Orders').doc(medName).set(careData);

    print('Medicine data added to Firestore.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Make order'),
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
                  labelText: 'Medicine Name',
                ),
                onChanged: (value) {
                  setState(() {
                    medName = value;
                  });
                },
              ),

              // Add buttons to increment/decrement medicine quantity
              SizedBox(height: 16),
              Text(
                'Quantity:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_medQuantity > 0) {
                          _medQuantity--;
                        }
                      });
                    },
                    child: Text('-'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFFF7378))),
                  ),
                  SizedBox(width: 16),
                  Text(
                    _medQuantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _medQuantity++;
                      });
                    },
                    child: Text('+'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFFF7378)), // Set the desired color
                    ),
                  ),
                ],
              ),

              // Add a button to submit user input
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  addData();
                },
                child: Text('Submit'),
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
