import 'package:flutter/material.dart';
import 'package:sehety/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:flutter/material.dart';
import 'package:sehety/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sehety/WelcomPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    late String email;
    late String password;
    return Scaffold(
        backgroundColor: Color(0xFF8692FD), // set the background color to green
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 20),
            Image.asset(
              'images/Humaaans.png', // Replace with the actual image path
              width: 350,
              height: 350,
            ),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              child: Card(
                elevation: 4, // Set the background color of the Card
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Josefin_Sans',
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            fontSize: 50,
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                    width: 4.0, color: Color(0xFFFF7378)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 10.0,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                    width: 4.0, color: Color(0xFFFF7378)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                print(credential);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      'Wrong password provided for that user.');
                                }
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WelcomePage(email: email),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              fixedSize: const Size(300, 50),
                              primary: Colors.white,
                              backgroundColor: Color(0xFFFF7378),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signupPage');
                              },
                              style: TextButton.styleFrom(
                                fixedSize: const Size(300, 50),
                                primary: Colors.blue,
                                backgroundColor: Colors.white,
                              ),
                              child: Text('Sign up a new account')),
                        ),
                        SizedBox(height: 55),
                      ]),
                ),
              ),
            )
          ]),
        ))));
  }
}
