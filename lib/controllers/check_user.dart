import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../firebase references/firebase_refs.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({Key? key}) : super(key: key);

  @override
  CheckUserState createState() => CheckUserState();
}

class CheckUserState extends State<CheckUser> {
  String position = '';
  final logger = Logger(); // Initialize a logger instance

  @override
  void initState() {
    super.initState();
    checkUserAndNavigate();
    fetchUser();
  }

  Future<void> checkUserAndNavigate() async {
    await fetchUser();
    logger.d('Position: $position'); // Use logger instead of print

    fireAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is not logged in, navigate to the LoginPage.
        Get.offAndToNamed("/login");
      } else {
        // User is logged in, navigate to the appropriate screen.
        Get.toNamed(position == 'manager' ? "/manager" : "/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> fetchUser() async {
    try {
      String uid = fireAuth.currentUser!.uid;

      DocumentSnapshot snapshot = await userColRef.doc(uid).get();

      if (snapshot.exists) {
        setState(() {
          position = snapshot['position'];
        });
      } else {
        // Handle the case where the user doesn't exist.
        logger.e('Error, user not found!');
      }
    } catch (e) {
      // Handle the error appropriately.
      logger.e('Error fetching user data: $e');
    }
  }
}
