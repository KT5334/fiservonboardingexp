import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Global {
//   static UserCredential? userCredential;
// }

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future handleLogin(BuildContext context) async {
    // get the information
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      //detect the user account.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // //save userCredential in global varible
      // Global.userCredential = userCredential;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successfully.')),
      );
      checkUserPosition();

      print('Username: $username, Password: $password');
      // If the authentication is successful, the user is logged in.
    } catch (e) {
      // If there's an error, show an error message.
      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter both username and password.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password.'),
          ),
        );
        print('Error during login');
      }
    }
    //
  }

  // Check user position
  void checkUserPosition() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('User').doc(uid).get();
        if (snapshot.exists) {
          String position = snapshot.data()!['position'];
          bool isFirstLogin = snapshot.data()!['firstlog'];
          // Determin logic based on position
          if (position == 'developer') {
            print('User is a developer.');
            // Update the 'firstlog' field if it's the first login
            if (isFirstLogin) {
              print("go to the teaser page");
              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(uid)
                  .update({'firstlog': false});
            }
          } else if (position == 'manager') {
            print('User is a manager.');
          } else {
            print('User position unknown.');
          }
        } else {
          print('User data not found in Firestore.');
        }
      } catch (e) {
        print('Error retrieving user data: $e');
      }
    } else {
      print('User not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate the user to the Home page
                handleLogin(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
