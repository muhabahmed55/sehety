import 'package:flutter/material.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class EditInfo extends StatefulWidget {
  String email;

  EditInfo({required this.email});

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        age = DateTime.now().difference(picked).inDays ~/ 365;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  FilePickerResult? result;
  String? imageURL;
  String? pdfURL;
  PlatformFile? pickedImage;
  PlatformFile? pickedPdf;
  UploadTask? uploadPdfFile;
  UploadTask? uploadTask;
  Future<void> uploadImage() async {
    final file = File(pickedImage!.path!);
    final fileName =
        '${widget.email}_profile_picture.jpg'; // Specify a unique file name
    final path =
        'Profile Picture/$fileName'; // Use the unique file name in the path
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    // Store the imageURL
    setState(() {
      imageURL = urlDownload;
    });

    print('Download link: $urlDownload');
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future uploadPdf() async {
    final file = File(pickedPdf!.path!);
    final path = 'Pdf/${widget.email}';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadPdfFile = ref.putFile(file);
    final snapshot = await uploadPdfFile!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    // Store the pdfURL
    setState(() {
      pdfURL = urlDownload;
      uploadPdf();
    });

    print('pdf here');
    print('Download link: $urlDownload');
  }

  Future<void> selectPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    setState(() {
      pickedPdf = result.files.first;
    });
  }

  late List users = [];
  late String profilePictureUrl = '';
  late String PdfUrl = '';
  late bool isLoading;

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

  @override
  void initState() {
    super.initState();
    isLoading = true; // Set isLoading to true initially
    getData();
    getImage(); // Call getImage method to fetch the image URL
  }

  getData() async {
    DocumentReference usersref =
        FirebaseFirestore.instance.collection("users").doc(widget.email);
    var responsebody = await usersref.get();
    setState(() {
      users = [responsebody.data()]; // initialize the variable here
    });
  }

  addData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users");
    DocumentSnapshot userSnapshot = await usersRef.doc(widget.email).get();

    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    if (firstName != null) {
      userData['fname'] = firstName;
    }
    if (lastName != null) {
      userData['lname'] = lastName;
    }
    if (age != null) {
      userData['age'] = age;
    }
    if (address != null) {
      userData['address'] = address;
    }
    if (phone != null) {
      userData['phone'] = phone;
    }
    if (height != null) {
      userData['height'] = height;
    }
    if (weight != null) {
      userData['weight'] = weight;
    }
    if (_bloodType != null) {
      userData['blood type'] = _bloodType;
    }
    if (_chronicType != null) {
      userData['Chronic disease'] = _chronicType;
    }
    if (imageURL != null) {
      userData['imageURL'] = imageURL;
    }
    if (pdfURL != null) {
      userData['pdfURL'] = pdfURL;
    }

    usersRef.doc(widget.email).update(userData);
  }

  List<String> _chronicType = [];
  String? _bloodType;
  String firstName = '';
  String lastName = '';
  int age = 0;
  String address = '';
  String phone = '';
  double height = 0.0;
  double weight = 0.0;
  List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> _chronic = [
    'Diabetes',
    'Cardiovascular disease',
    'Chronic obstructive pulmonary disease (COPD)',
    'Cancer',
    'Alzheimer’s disease and dementia',
    'Obesity',
    'Arthritis',
    'Chronic kidney disease',
    'Depression',
    'Osteoporosis',
    'None',
  ];

  InputDecoration commonDecoration(String labelText, IconData prefixIcon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey, // Customize the label text color
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Color(0xFF8692FD), // Customize the border color
        ),
        borderRadius: BorderRadius.circular(10), // Customize the border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Color(0xFFFF7378), // Customize the focused border color
        ),
        borderRadius: BorderRadius.circular(10), // Customize the border radius
      ),
      filled: true,
      fillColor: Colors.white, // Customize the fill color
      prefixIcon: Icon(prefixIcon), // Add an icon to the prefix
    );
  }

  InputDecoration commonFormFieldDecoration(
      String labelText, IconData prefixIcon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey, // Customize the label text color
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Color(0xFF8692FD), // Customize the border color
        ),
        borderRadius: BorderRadius.circular(10), // Customize the border radius
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFFF7378), // Customize the focused border color
        ),
        borderRadius: BorderRadius.circular(10), // Customize the border radius
      ),
      filled: true,
      fillColor: Colors.white, // Customize the fill color
      prefixIcon: Icon(prefixIcon), // Add an icon to the prefix
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8692FD),
        title: Text('Edit Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (pickedImage != null)
              SizedBox(
                height: 200,
                width: 200,
                child: ClipOval(
                  child: Image.file(
                    File(pickedImage!.path!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 200,
                height: 200,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      100.0), // Set the desired border radius
                  color: Colors.blue, // Set a background color if needed
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(profilePictureUrl),
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: selectImage,
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF7378), // Set the background color
                onPrimary: Colors.white, // Set the text color
                minimumSize: Size(200, 40), // Set the button size
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(70), // Set the border radius
                ),
              ),
              child: Text(
                'Change Image',
                style: TextStyle(fontSize: 18), // Set the text size
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: Card(
                color: Color(0xFFDEE2FF),
                elevation: 4, // Set the background color of the Card
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration:
                            commonDecoration('First Name', Icons.person),
                        onChanged: (value) {
                          setState(() {
                            firstName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: commonDecoration('Last Name', Icons.person),
                        onChanged: (value) {
                          setState(() {
                            lastName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _dateController,
                        decoration: commonDecoration(
                            'Date of Birth', Icons.calendar_today),
                        onTap: _selectDate,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: commonDecoration('Address', Icons.home),
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: commonDecoration('Phone', Icons.phone),
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: commonDecoration('Height', Icons.height),
                        onChanged: (value) {
                          setState(() {
                            height = double.tryParse(value) ?? 0.0;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration:
                            commonDecoration('Weight', Icons.fitness_center),
                        onChanged: (value) {
                          setState(() {
                            weight = double.tryParse(value) ?? 0.0;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey, // Customize the border color
                          ),
                          color: Colors.white, // Customize the fill color
                        ),
                        child: MultiSelectFormField(
                          fillColor: Colors
                              .transparent, // Set the fill color to transparent
                          title: Text('Chronic diseases'),
                          dataSource: _chronic.map((disease) {
                            return {
                              "display": disease,
                              "value": disease,
                            };
                          }).toList(),
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          initialValue: _chronicType,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              _chronicType = value.cast<String>();
                              for (int i = 0; i < _chronicType.length; i++) {
                                print(_chronicType[i]);
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select at least one chronic disease';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        decoration: commonFormFieldDecoration(
                            'Blood Type', Icons.bloodtype),
                        value: _bloodType,
                        items: _bloodTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _bloodType = newValue;
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
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: selectPdf,
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color(0xFFFF7378), // Set the background color
                          onPrimary: Colors.white, // Set the text color
                          minimumSize: Size(200, 40), // Set the button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                70), // Set the border radius
                          ),
                        ),
                        child: Text(
                          'Pick Pdf',
                          style: TextStyle(fontSize: 18), // Set the text size
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (pickedImage != null) {
                            await uploadImage();
                          }
                          if (pickedPdf != null) {
                            await uploadPdf();
                          }
                          await addData();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WelcomePage(email: widget.email)),
                          );
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
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
            )
          ]),
        ),
      ),
    );
  }
}
