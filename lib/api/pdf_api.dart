/*
To test pdf generation & email: Please go to firestore, set introduced
filed to false (if you are unable to see the button.)
 */
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiservonboardingexp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sendgrid_mailer/sendgrid_mailer.dart' as sgm;

class PdfApi {
  PdfApi(this.context);
  final BuildContext context;

  User? user = FirebaseAuth.instance.currentUser;
  late String firstName;
  late String lastName;
  late String hobbies;
  late String interestingFacts;
  late String futureSelf;
  Uint8List? imageData;

  Future<File> generate() async {
    final pdf = pw.Document();
    const pageTheme = pw.PageTheme(pageFormat: PdfPageFormat.a4);
    await fetchUser();
    await fetchImageData();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          customHeader(),
          pw.SizedBox(height: 10),
          //${user!.email?.split('@')[0]}/profile_${user!.email?.split('@')[0]}
          imageData != null
              ? pw.Center(
                  child: pw.ClipRRect(
                    horizontalRadius: 32,
                    verticalRadius: 32,
                    child: pw.Image(
                      pw.MemoryImage(imageData!),
                      width: pageTheme.pageFormat.availableWidth / 2,
                    ),
                  ),
                )
              : pw.Center(
                  child: pw.Text('No Image Available',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold))),
          customHeadline(firstName, lastName),
          pw.Header(
            child: pw.Text(
              'Biography',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
          ),
          pw.Paragraph(
            text: interestingFacts,
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Header(
            child: pw.Text(
              'Hobbies',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
          ),
          pw.Paragraph(
            text: hobbies,
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Header(
            child: pw.Text(
              'Future Aspirations',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
          ),
          pw.Paragraph(
            text: futureSelf,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );

    return saveToTemporaryFile(pdf);
  }

  Future<void> fetchImageData() async {
    final reference = firebase_storage.FirebaseStorage.instance.ref().child(
        '${user!.email?.split('@')[0]}/profile_${user!.email?.split('@')[0]}.jpg');

    try {
      //final metadata = await reference.getMetadata();
      imageData = await reference.getData(1000000);
    } catch (error) {
      if (error is firebase_storage.FirebaseException &&
          error.code == 'object-not-found') {
        imageData = null;
      } else {
        debugPrint('There was an error fetching image data.\nError: $error');
      }
    }
  }

  static pw.Widget customHeadline(String firstName, String lastName) =>
      pw.Header(
        child: pw.Center(
          child: pw.Text(
            '$firstName $lastName',
            style: pw.TextStyle(
                fontSize: 21,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white),
          ),
        ),
        decoration: const pw.BoxDecoration(color: PdfColors.grey700),
      );

  static pw.Widget customHeader() => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(width: 2, color: PdfColors.blue),
          ),
        ),
        child: pw.Center(
          child: pw.Text(
            'Welcome to Fiserv',
            style: const pw.TextStyle(fontSize: 24, color: PdfColors.blue),
          ),
        ),
      );

  Future<File> saveToTemporaryFile(pw.Document pdf) async {
    // Generate the pedf and save it into firebase.
    final uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${user!.email?.split('@')[0]}';
    final storageRef = firebase_storage.FirebaseStorage.instance.ref();

    final folderRef = storageRef.child('${user!.email?.split('@')[0]}/');
    final pdfRef = folderRef.child(uniqueFileName);

    final bytes = await pdf.save();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${user!.email?.split('@')[0]}.pdf');

    await file.writeAsBytes(bytes);
    await pdfRef.putFile(file);

    //Sending email to test recipient
    final mailer = sgm.Mailer(
        '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');

    //Change toAddress to your own email for testing.
    const toAddress = sgm.Address('rndproject96@gmail.com');
    const fromAddress = sgm.Address('rndproject96@gmail.com');
    const subject = 'Here comes a new challenger!';
    const personalization = sgm.Personalization([toAddress]);
    // Create the email content with the PDF download link
    Future<sgm.Content> createEmailContent() async {
      final pdfDownloadURL = await pdfRef.getDownloadURL();
      final content = sgm.Content('text/plain',
          'Please welcome the new member of our team! Say hi when you see them in the office.\n\nView their info here: $pdfDownloadURL');
      return content;
    }

    final contentFuture = createEmailContent();

    contentFuture.then((content) {
      final email = sgm.Email([personalization], fromAddress, subject,
          content: [content]);

      mailer.send(email).then((result) {
        debugPrint('Email Sent: ${result.isValue}');
        if (result.isValue) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              ThemeData selectedTheme = getSelectedTheme(context);
              return AlertDialog(
                backgroundColor: selectedTheme.colorScheme.onBackground,
                title: Text(
                  'Notice:',
                  style: TextStyle(
                    color: selectedTheme.colorScheme.primary,
                  ),
                ),
                content: Text(
                  'An introduction has been sent out to your colleagues!',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: selectedTheme.colorScheme.primary),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close',
                        style: TextStyle(
                            color: selectedTheme.colorScheme.secondary)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              ThemeData selectedTheme = getSelectedTheme(context);
              return AlertDialog(
                backgroundColor: selectedTheme.colorScheme.onBackground,
                title: Text(
                  'Notice:',
                  style: TextStyle(
                    color: selectedTheme.colorScheme.primary,
                  ),
                ),
                content: Text(
                  'Something went wrong. Please try again.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: selectedTheme.colorScheme.primary,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Close',
                      style:
                          TextStyle(color: selectedTheme.colorScheme.secondary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  Future<void> fetchUser() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final userCollection = FirebaseFirestore.instance.collection('User');

      DocumentSnapshot snapshot = await userCollection.doc(uid).get();

      if (snapshot.exists) {
        firstName = snapshot['firstName'];
        lastName = snapshot['lastName'];
        interestingFacts = snapshot['Interesting Facts'];
        hobbies = snapshot['Hobbies'];
        futureSelf = snapshot['Future Self'];
      } else {
        pw.Center(child: pw.Text('Error, user not found!'));
      }
    } catch (e) {
      pw.Center(child: pw.Text('Error fetching user data: $e'));
    }
  }
}
