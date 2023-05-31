import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sehety/Reminder.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/addMedicine/step3.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MedicationFrequency { onceDaily, twiceDaily, threeTimesDaily, onNeed }

class AddMedicineStep2 extends StatefulWidget {
  String email;
  String medName;
  String? unit;

  AddMedicineStep2(
      {required this.email, required this.medName, required this.unit});

  @override
  _AddMedicineStep2State createState() => _AddMedicineStep2State();
}

class _AddMedicineStep2State extends State<AddMedicineStep2> {
  void addData() async {
    final databaseReference = FirebaseFirestore.instance;
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    String frequency;
    switch (_medDosage) {
      case MedicationFrequency.onceDaily:
        frequency = 'Once Daily';
        break;
      case MedicationFrequency.twiceDaily:
        frequency = 'Twice Daily';
        break;
      case MedicationFrequency.threeTimesDaily:
        frequency = 'Three Times Daily';
        break;
      case MedicationFrequency.onNeed:
        frequency = 'On Need';
        break;
      default:
        frequency = '';
        break;
    }

    Map<String, dynamic> medicineData = {
      'frequency': frequency,
    };

    await documentReference
        .collection('Medicine')
        .doc(widget.medName)
        .set(medicineData);

    print('Medicine data added to Firestore.');
  }

  MedicationFrequency? _medDosage;
  List<MedicationFrequency> _medFrequencyOptions = [
    MedicationFrequency.onceDaily,
    MedicationFrequency.twiceDaily,
    MedicationFrequency.threeTimesDaily,
    MedicationFrequency.onNeed,
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
              widget.medName,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'How often do you take this medication?',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.white,
              child: Column(
                children: _medFrequencyOptions.map((option) {
                  return RadioListTile<MedicationFrequency>(
                    title: Text(
                      _getFrequencyText(option),
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    value: option,
                    groupValue: _medDosage,
                    onChanged: (MedicationFrequency? value) {
                      setState(() {
                        _medDosage = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_medDosage == MedicationFrequency.onNeed) {
                  // Navigate to the Reminder screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Reminder(email: widget.email),
                    ),
                  );
                } else {
                  // Navigate to the Step 2 screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMedicineStep3(
                        email: widget.email,
                        medName: widget.medName,
                        freq: _medDosage.toString(),
                        unit: widget.unit,
                      ),
                    ),
                  );
                }
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

  String _getFrequencyText(MedicationFrequency frequency) {
    switch (frequency) {
      case MedicationFrequency.onceDaily:
        return 'Once Daily';
      case MedicationFrequency.twiceDaily:
        return 'Twice Daily';
      case MedicationFrequency.threeTimesDaily:
        return 'Three Times Daily';
      case MedicationFrequency.onNeed:
        return 'On Need';
    }
  }
}
