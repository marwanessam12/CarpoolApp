import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/user/homescreen1.dart';
import 'package:carpool/features/home/presentation/widgets/controllers/signup_controller.dart';
import 'package:carpool/features/home/presentation/widgets/pasfieldsignin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/common_appbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signIn() async {
    String email = SignUpController.email.text.trim();
    String password = SignUpController.password.text.trim();

    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Get the user ID and store it in userId
        userId = userQuery.docs.first.id;
        print('User ID: $userId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        _showErrorDialog("Invalid email or password.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const CommonAppbar(),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Your Email & Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: SignUpController.email,
                      onChanged: (value) => userEmail = value,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email@nu.edu.eg',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    PasswordField(),
                    const Row(
                      children: [
                        Text(
                          "\nForget Password?\n",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        onPressed: _signIn,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
