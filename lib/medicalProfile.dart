import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/editInfo.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sehety/pdfViewer.dart';

class MedicalInfo extends StatefulWidget {
  String email;

  MedicalInfo({required this.email});

  @override
  _MedicalInfoState createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  late List users = [];
  late String profilePictureUrl = '';
  late String PdfUrl = '';
  late bool isLoading;
  getPdf() async {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection("users").doc(widget.email);
    var response = await usersRef.get();
    setState(() {
      if (response.exists) {
        users = [response.data() as Map<String, dynamic>];
        if (users[0]['pdfURL'] != null) {
          PdfUrl = users[0]['pdfURL'] as String;
        } else {
          PdfUrl = ''; // Set a default value if imageURL is null
        }
      }
    });
  }

  getImage() async {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection("users").doc(widget.email);
    var response = await usersRef.get();
    setState(() {
      if (response.exists) {
        users = [response.data() as Map<String, dynamic>];
        if (users[0]['imageURL'] != null) {
          profilePictureUrl = users[0]['imageURL'] as String;
        } else {
          profilePictureUrl = ''; // Set a default value if imageURL is null
        }
      }
      isLoading = false;
    });
  }

  getData() async {
    DocumentReference usersref =
        FirebaseFirestore.instance.collection("users").doc(widget.email);
    var responsebody = await usersref.get();
    setState(() {
      users = [responsebody.data()]; // initialize the variable here
    });
  }

  List medicineList = [];
  getMed() async {
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

  @override
  void initState() {
    super.initState();
    isLoading = true; // Set isLoading to true initially
    getData();
    getPdf();
    getMed();
    getImage(); // Call getImage method to fetch the image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Medical Information'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Color(0xFF8692FD),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100.0), // Set the desired border radius
                          color:
                              Colors.blue, // Set a background color if needed
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(profilePictureUrl),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("First Name: ${users[0]['fname']}"),
                        subtitle: Text("Last Name: ${users[0]['lname']}"),
                      ),
                      ListTile(
                        title: Text("Address: ${users[0]['address']}"),
                      ),
                      ListTile(
                        title: Text("Age: ${users[0]['age']}"),
                      ),
                      ListTile(
                        title: Text("Blood Type: ${users[0]['blood type']}"),
                      ),
                      ListTile(
                        title: Text("Height: ${users[0]['height']}"),
                      ),
                      ListTile(
                        title: Text("Phone: ${users[0]['phone']}"),
                      ),
                      ListTile(
                        title: Text("Weight: ${users[0]['weight']}"),
                      ),
                      ListTile(
                        title: Text("Diseases: ${users[0]['Chronic disease']}"),
                      ),
                      ListTile(
                        title: Text(
                            "Medicines: ${medicineList.isNotEmpty ? medicineList[0]['name'] : 'No Medicines'}"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color(0xFF8692FD), // Set the background color
                          onPrimary: Colors.white, // Set the text color
                          minimumSize: Size(200, 40), // Set the button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                70), // Set the border radius
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewerPage(pdfUrl: PdfUrl),
                              ));
                          print(PdfUrl);
                          getPdf();
                        },
                        child: Text('Show Medical Profile'),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF7378),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditInfo(email: widget.email)),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
