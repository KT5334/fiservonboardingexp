import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiservonboardingexp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firebase references/firebase_refs.dart';

class ChecklistTile extends StatelessWidget {
  final Map<String, dynamic> task;
  Function(bool?)? onChanged;
  final FirebaseFirestore firestore;

  ChecklistTile({
    required this.task,
    required this.onChanged,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    bool taskCompleted = task['taskCompleted'];

    // UI of the Checklist Tiles
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: fiservColor,
              ),
              child: Checkbox(
                value: taskCompleted,
                onChanged: (value) {
                  String uid = fireAuth.currentUser!.uid;
                  firestore
                      .collection('User')
                      .doc(uid)
                      .collection('Checklist')
                      .doc('List')
                      .update({task['taskName']: value}).then((_) {
                    onChanged?.call(value);
                  }).catchError((error) {
                    print(
                        "Error updating Firestore: $error"); // Error Handling but idk too much about it tbh
                  });
                },
                activeColor: fiservColor, // Checkbox checked colour HERE
              ),
            ),
            Flexible(
              child: Text(
                task[
                    'taskName'], // Task name display and stuff below it is the text style (font, colour, size, etc)
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
