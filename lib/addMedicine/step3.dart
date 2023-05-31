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

class AddMedicineStep3 extends StatefulWidget {
  String email;
  String medName;
  String freq;
  String? unit;
  AddMedicineStep3(
      {required this.email,
      required this.medName,
      required this.freq,
      required this.unit});

  @override
  _AddMedicineStep3State createState() => _AddMedicineStep3State();
}

class _AddMedicineStep3State extends State<AddMedicineStep3> {
  void addData() async {
    final databaseReference = FirebaseFirestore.instance;
    DocumentReference documentReference =
        databaseReference.collection('users').doc(widget.email);

    List<String> selectedTimesString = [];
    for (TimeOfDay time in selectedTimes) {
      selectedTimesString.add(time.format(context));
    }

    Map<String, dynamic> medicineData = {
      'time': selectedTimesString,
      'note': note,
    };

    await documentReference
        .collection('Medicine')
        .doc(widget.medName)
        .set(medicineData);

    print('Medicine data added to Firestore.');
  }

  TimeOfDay time = TimeOfDay.now();
  TimeOfDay time2 = TimeOfDay.now();
  TimeOfDay time3 = TimeOfDay.now();

  // Define variables to store user input
  List<TimeOfDay> selectedTimes = [];
  String note = '';

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
                'What time do you want to be reminded?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              if (widget.freq == 'MedicationFrequency.onceDaily')
                Container(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('First intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (widget.freq == 'MedicationFrequency.twiceDaily')
                Container(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('First intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Second intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time2,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time2 = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time2.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (widget.freq == 'MedicationFrequency.threeTimesDaily')
                Container(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('First intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Second intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time2,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time2 = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time2.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Third intake'),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Time: '),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? newTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: time3,
                                          );

                                          if (newTime == null) return;

                                          setState(() {
                                            time3 = newTime;
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
                                            scheduledNotificationDateTime:
                                                scheduleTime,
                                          );
                                        },
                                        child: Text(
                                          '${time3.format(context)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Dose: '),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter dose',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'in ${widget.unit}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Text('Add Note'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text('Notes: '),
                      Expanded(
                          child: TextField(
                              decoration: InputDecoration(
                                hintText: 'E.g: After breakfast.',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              onChanged: (value) {
                                setState(
                                  () {
                                    note = value;
                                  },
                                );
                              }))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  addData();
                },
                child: Text('Add Medicine'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size(300, 50),
                  primary: Colors.white,
                  backgroundColor: Color(0xFF8692FD),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
