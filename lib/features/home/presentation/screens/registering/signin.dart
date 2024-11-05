import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/user/homescreen1.dart';
import 'package:carpool/features/home/presentation/widgets/controllers/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_bars/common_appbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = SignUpController.email;
  final TextEditingController passwordController = SignUpController.password;

  String? emailError;
  String? passwordError;
  bool _isPasswordVisible = false; // Variable to manage password visibility

  Future<void> _signIn() async {
    setState(() {
      emailError =
          emailController.text.trim().isEmpty ? "This field is required" : null;
      passwordError = passwordController.text.trim().isEmpty
          ? "This field is required"
          : null;
    });

    if (emailError != null || passwordError != null) return;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (userQuery.docs.isNotEmpty) {
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
                      controller: emailController,
                      onChanged: (value) => setState(() {
                        emailError = null;
                      }),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: emailError,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                emailError != null ? Colors.red : Colors.grey,
                          ),
                        ),
                        hintText: 'Enter your email@nu.edu.eg',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: passwordController,
                      onChanged: (value) => setState(() {
                        passwordError = null;
                      }),
                      obscureText: !_isPasswordVisible, // Manage visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: passwordError,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: passwordError != null
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          // IconButton for visibility toggle
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle the state
                            });
                          },
                        ),
                      ),
                    ),
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
