import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/otp_screen.dart';
import 'package:carpool/features/home/presentation/widgets/Passfieldsignup.dart';
import 'package:carpool/features/home/presentation/widgets/common_appbar.dart';
import 'package:carpool/features/home/presentation/widgets/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/user repository/user_repository.dart';
import '../../data/user_model.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userRepo = Get.put(UserRepository());
  void createUser(UserModel user) {
    userRepo.createUser((user));
  }

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
                    const SizedBox(
                      height: 25.0,
                    ), //register

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.firstname,
                            onChanged: (value) => userName = value,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'First Name',
                            ),
                          ),
                        ), //first name
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.lastname,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'Last Name',
                            ),
                          ),
                        ), //last name
                      ],
                    ), //name
                    const SizedBox(
                      height: 15.0,
                    ),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: controller.id,
                      onChanged: (value) => userId = value,
                      decoration: const InputDecoration(
                        labelText: 'ID',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        hintText: 'ID',
                      ),
                    ), //ID
                    const SizedBox(
                      height: 15.0,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: controller.age,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'Age',
                            ),
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
                            },
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'Select Gender',
                            ),
                          ),
                        ),
                      ],
                    ), //age& gender
                    const SizedBox(
                      height: 15.0,
                    ),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: controller.mobileNumber,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        hintText: 'Mobile Number',
                      ),
                    ), //Mobile number
                    const SizedBox(
                      height: 15.0,
                    ),

                    TextField(
                      controller: controller.email,
                      onChanged: (value) => userEmail = value,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email@nu.edu.eg',
                      ),
                    ), //email
                    const SizedBox(
                      height: 15.0,
                    ),

                    PasswordForm(
                      passwordFieldController: controller.password,
                    ),

                    // TextField(
                    //   controller: controller.password,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Password',
                    //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Password',
                    //   ),
                    // ), //password
                    // const SizedBox(
                    //   height: 15.0,
                    // ),
                    //
                    // const TextField(
                    //   decoration: InputDecoration(
                    //     labelText: 'Confirm Password',
                    //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Confirm Password ',
                    //   ),
                    // ), //confirm password
                    const SizedBox(
                      height: 25.0,
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        onPressed: () {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: controller.email.text,
                            password: controller.password.text,
                          )
                              .then((value) async {
                            // Once the user is created, store their info in Firestore
                            final user = UserModel(
                              firstname: controller.firstname.text.trim(),
                              lastname: controller.lastname.text.trim(),
                              age: int.parse(controller.age.text.trim()),
                              gender: controller.gender.text.trim(),
                              id: int.parse(controller.id.text.trim()),
                              email: controller.email.text.trim(),
                              mobileNumber: controller.mobileNumber.text.trim(),
                              password: controller.password.text.trim(),
                            );

                            SignUpController.instance.createUser(user);
                          });
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return OtpScreen(email: controller.email.text);
                            },
                          ));
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
                    ), //register button
                    const SizedBox(
                      height: 25.0,
                    ),

                    Row(
                      children: [
                        const Text(
                          "I already have account, ",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
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
                            textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}
