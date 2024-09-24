import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/homescreen1.dart';
import 'package:carpool/features/home/presentation/widgets/pasfieldsignin.dart';
import 'package:flutter/material.dart';

import '../widgets/common_appbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailFieldController = TextEditingController();
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Your Email & Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: emailFieldController,
                    onChanged: (value) => userEmail = value,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email@nu.edu.eg',
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // const TextField(
                  //
                  //   decoration: InputDecoration(
                  //     labelText: 'Password',
                  //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Password',
                  //   ),
                  // ),
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ]),
          ))
        ],
      ),
    ));
  }
}
