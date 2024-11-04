import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/registering/otp_screen.dart';
import 'package:carpool/features/home/presentation/widgets/Passfieldsignup.dart';
import 'package:carpool/features/home/presentation/widgets/app_bars/common_appbar.dart';
import 'package:carpool/features/home/presentation/widgets/controllers/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../repository/user repository/user_repository.dart';
import '../../../data/user_model.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userRepo = Get.put(UserRepository());

  bool isEmailUnique = true; // Variable to track email uniqueness

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const CommonAppbar(),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 40.0,
                        ),
                      ),
                      const Text("Create your account"),
                      const SizedBox(height: 25.0),

                      // First and last name fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.firstname,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                hintText: 'First Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                  _formKey.currentState!
                                      .validate(); // Manually trigger validation
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: controller.lastname,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                hintText: 'Last Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _formKey.currentState!
                                      .validate(); // Manually trigger validation
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),

                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: SignUpController.id,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ], // Restrict to numbers only

                        onChanged: (value) {
                          setState(() {
                            userId = value;
                            _formKey.currentState!
                                .validate(); // Manually trigger validation
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'ID',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'ID',
                        ),
                        // Validation logic
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ID cannot be empty';
                          } else if (value.length > 10) {
                            return 'ID cannot be more than 10 digits';
                          }
                          return null;
                        },
                      ), //ID
                      const SizedBox(
                        height: 15.0,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _formKey.currentState!
                                      .validate(); // Manually trigger validation
                                });
                              },
                              controller: controller.age,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                hintText: 'Age',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Age cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ), //AGE
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.gender.text.isEmpty
                                  ? null
                                  : controller.gender.text,
                              items: ['Male', 'Female'].map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Update the controller with the selected value
                                controller.gender.text = newValue ?? '';
                                setState(() {
                                  _formKey.currentState!
                                      .validate(); // Manually trigger validation
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                                hintText: 'Select Gender',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Gender cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ), //age& gender
                      const SizedBox(
                        height: 15.0,
                      ),

                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          setState(() {
                            _formKey.currentState!
                                .validate(); // Manually trigger validation
                          });
                        },
                        controller: controller.mobileNumber,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Mobile Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile Number cannot be empty';
                          } else if (value.length != 11) {
                            return 'Mobile Number must be exactly 11 digits';
                          }
                          return null;
                        },
                      ), //Mobile number
                      const SizedBox(
                        height: 15.0,
                      ),

                      // Email field with unique check
                      TextFormField(
                        controller: SignUpController.email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email@nu.edu.eg',
                        ),
                        onChanged: (value) async {
                          // Check Firestore for email uniqueness
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: value)
                              .get();

                          setState(() {
                            isEmailUnique = querySnapshot.docs.isEmpty;
                          });
                          userEmail = value;
                          _formKey.currentState!
                              .validate(); // Trigger validation
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@nu\.edu\.eg$')
                              .hasMatch(value)) {
                            return 'Invalid email address';
                          } else if (!isEmailUnique) {
                            return 'Email already exists';
                          }
                          return null;
                        },
                      ),

                      // Other fields (age, gender, password, etc.)
                      const SizedBox(height: 15.0),
                      PasswordForm(
                        formKey: _formKey,
                      ),

                      const SizedBox(height: 25.0),

                      // Register button
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: SignUpController.email.text,
                                password: SignUpController.password.text,
                              )
                                  .then((value) async {
                                final user = UserModel(
                                  firstname: controller.firstname.text.trim(),
                                  lastname: controller.lastname.text.trim(),
                                  age: int.parse(controller.age.text.trim()),
                                  gender: controller.gender.text.trim(),
                                  id: int.parse(
                                      SignUpController.id.text.trim()),
                                  email: SignUpController.email.text.trim(),
                                  mobileNumber:
                                      controller.mobileNumber.text.trim(),
                                  password:
                                      SignUpController.password.text.trim(),
                                );

                                SignUpController.instance.createUser(user);
                              });

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return OtpScreen(
                                      email: SignUpController.email.text);
                                },
                              ));
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25.0),

                      Row(
                        children: [
                          const Text(
                            "I already have account, ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                              );
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
