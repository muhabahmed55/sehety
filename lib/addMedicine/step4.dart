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
import 'package:sehety/notification.dart';
import 'package:sehety/notification.dart';

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}

DateTime scheduleTime = DateTime.now();

class AddMedicine extends StatefulWidget {
  String email;

  AddMedicine({required this.email});

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  int _selectedButtonIndex = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
      if (_selectedButtonIndex == 0) {
        medType = 'Capsule';
      } else if (_selectedButtonIndex == 1) {
        medType = 'Syrup';
      } else if (_selectedButtonIndex == 2) {
        medType = 'Injection';
      }
    });
  }

  void addData() async {
    final databaseReference = FirebaseFirestore.instance;
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    // Convert the list of TimeOfDay objects to a list of strings
    List<String> selectedTimesString = [];
    for (TimeOfDay time in selectedTimes) {
      selectedTimesString.add(time.format(context));
    }

    Map<String, dynamic> medicineData = {
      'name': medName,
      'medicine type': medType,
      'quantity': _medDosage,
      'time': selectedTimesString,
      'note': note, // Store the list of strings in Firestore
    };

    await documentReference
        .collection('Medicine')
        .doc(medName)
        .set(medicineData);

    print('Medicine data added to Firestore.');
  }

  TimeOfDay time = TimeOfDay.now();

  // Define variables to store user input
  List<TimeOfDay> selectedTimes = [];
  String? _medDosage;
  String? injectionDose;
  String? medType;
  int _medTiming = 1;
  String medName = '';
  String note = '';
  List<String> _medDose = ['1', '2', '3', '4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f4f8),
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(style: TextStyle(fontSize: 20), 'Medicine Type'),
              SizedBox(height: 20),
              Container(
                // Set the desired width
                child: Row(
                  children: [
                    Expanded(
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(30),
                        selectedColor: Colors.white,
                        color: Colors.grey,
                        fillColor: Color(0xFFFF7378),
                        borderWidth: 2,
                        borderColor: Color(0xFFFF7378),
                        selectedBorderColor: Color(0xFFFF7378),
                        isSelected: [
                          _selectedButtonIndex == 0,
                          _selectedButtonIndex == 1,
                          _selectedButtonIndex == 2,
                        ],
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                              ),
                              Icon(Icons.info),
                              SizedBox(width: 8),
                              Text('Capsule'),
                              SizedBox(
                                width: 22,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                              ),
                              Icon(Icons.settings),
                              SizedBox(width: 8),
                              Text('Syrup'),
                              SizedBox(
                                width: 22,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                              ),
                              Icon(Icons.help),
                              SizedBox(width: 8),
                              Text('Injection'),
                              SizedBox(
                                width: 22,
                              ),
                            ],
                          ),
                        ],
                        onPressed: (index) => _onButtonPressed(index),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Visibility(
                      visible: _selectedButtonIndex == 0,
                      child: Column(
                        children: [
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
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Dose Amount',
                            ),
                            value: _medDosage,
                            items: _medDose.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _medDosage = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a blood type';
                              }
                              return null;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Number of Doses',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _medTiming = int.parse(value);
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_medTiming != null)
                            for (int i = 0; i < _medTiming; i++)
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (newTime == null) return;

                                  setState(() {
                                    selectedTimes.add(newTime);
                                  });

                                  // Set the notification using the selected time
                                  DateTime now = DateTime.now();
                                  DateTime scheduleTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );

                                  await NotificationService()
                                      .scheduleNotification(
                                    title: 'Scheduled Notification',
                                    body: '$scheduleTime',
                                    scheduledNotificationDateTime: scheduleTime,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Set Reminder',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFF7378),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  fixedSize: Size(300, 50),
                                ),
                              ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Notes',
                            ),
                            onChanged: (value) {
                              setState(() {
                                note = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(medType);
                              addData();
                            },
                            child: Text('Add Medicine'),
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
                    Visibility(
                      visible: _selectedButtonIndex == 1,
                      child: Column(
                        children: [
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
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Number of Doses',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _medTiming = int.parse(value);
                              });
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Tbs Amount',
                            ),
                            value: _medDosage,
                            items: _medDose.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _medDosage = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a blood type';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_medTiming != null)
                            for (int i = 0; i < _medTiming; i++)
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  if (newTime == null) return null;
                                  setState(() {
                                    selectedTimes.add(newTime);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .alarm, // Replace with the desired icon
                                      size:
                                          18, // Adjust the icon size as needed
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add spacing between the icon and text
                                    Text(
                                      'Set Reminder',
                                      style: TextStyle(
                                        fontSize:
                                            14, // Adjust the font size as needed
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFFFF7378), // Set the button's background color
                                  onPrimary: Colors
                                      .white, // Set the button's text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Set the button's border radius
                                  ),
                                  fixedSize: Size(300,
                                      50), // Set the button's width and height
                                ),
                              ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Notes',
                            ),
                            onChanged: (value) {
                              setState(() {
                                note = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(medType);
                              addData();
                            },
                            child: Text('Add Medicine'),
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
                    Visibility(
                      visible: _selectedButtonIndex == 2,
                      child: Column(
                        children: [
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
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Number of Doses',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _medTiming = int.parse(value);
                              });
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Dose Amount (in ml)',
                            ),
                            onChanged: (value) {
                              setState(() {
                                injectionDose = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_medTiming != null)
                            for (int i = 0; i < _medTiming; i++)
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  if (newTime == null) return null;
                                  setState(() {
                                    selectedTimes.add(newTime);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .alarm, // Replace with the desired icon
                                      size:
                                          18, // Adjust the icon size as needed
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add spacing between the icon and text
                                    Text(
                                      'Set Reminder',
                                      style: TextStyle(
                                        fontSize:
                                            14, // Adjust the font size as needed
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      0xFFFF7378), // Set the button's background color
                                  onPrimary: Colors
                                      .white, // Set the button's text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Set the button's border radius
                                  ),
                                  fixedSize: Size(300,
                                      50), // Set the button's width and height
                                ),
                              ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Notes',
                            ),
                            onChanged: (value) {
                              setState(() {
                                note = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(medType);
                              addData();
                            },
                            child: Text('Add Medicine'),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
