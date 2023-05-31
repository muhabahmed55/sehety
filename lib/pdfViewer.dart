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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  PdfViewerPage({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    print('PDF URL: $pdfUrl'); // Print the pdfUrl
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8692FD),
          title: Text('Medical Profile'),
        ),
        body: Container(
          child: SfPdfViewer.network(pdfUrl),
        ));
  }
}
