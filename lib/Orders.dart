import 'package:flutter/material.dart';
import 'package:sehety/WelcomPage.dart';
import 'package:sehety/addCareTaker.dart';
import 'package:sehety/addMedicine.dart';
import 'package:sehety/loginPage.dart';
import 'package:sehety/main.dart';
import 'package:sehety/Signup.dart';
import 'package:sehety/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sehety/makeOrder.dart';

class Orders extends StatefulWidget {
  String email;
  Orders({required this.email});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List orderList = []; // change to List<Map<String, dynamic>>

  getData() async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users"); // change to "users"

    DocumentReference orderRef = usersRef.doc(widget.email);

    CollectionReference orderListRef = orderRef.collection('Orders');
    var responsebody = await orderListRef.get();
    responsebody.docs.forEach((element) {
      setState(() {
        orderList.add(element.data());
      });
      ;
    });
    print(orderList);
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
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, i) {
          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blue[100],
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Name: ${orderList[i]['name']}"),
                  ),
                  ListTile(
                    title: Text("Quantity: ${orderList[i]['quantity']}"),
                  )
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF7378),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MakeOrder(email: widget.email)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
