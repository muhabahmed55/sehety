import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sehety/Reminder.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sehety/addMedicine/step2.dart';

class AddMedicineStep1 extends StatefulWidget {
  String email;

  AddMedicineStep1({required this.email});

  @override
  _AddMedicineStep1State createState() => _AddMedicineStep1State();
}

class _AddMedicineStep1State extends State<AddMedicineStep1> {
  void addData() async {
    final databaseReference = FirebaseFirestore.instance;
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    Map<String, dynamic> medicineData = {
      'name': medName,
      'unit': _unit,
    };

    await documentReference
        .collection('Medicine')
        .doc(medName)
        .set(medicineData);

    print('Medicine data added to Firestore.');
  }

  String medName = '';
  String? _unit;
  List<String> unit = [
    'Pill(s)',
    'Patch(s)',
    'Spray(s)',
    'Teaspoon(s)',
    'Tablespoon(s)',
    'Unit',
    'Gram(s)',
    'Milligram(s)',
    'Drop(s)',
    'Injection',
    'Capsule(s)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f4f8),
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Add Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What medication do you want to set the reminder for?',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Medicine',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          medName = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Unit:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'Pills',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      value: _unit,
                      items: unit.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _unit = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a unit';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                addData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMedicineStep2(
                            email: widget.email,
                            medName: medName,
                            unit: _unit,
                          )),
                );
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Color(0xFF8692FD),
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
