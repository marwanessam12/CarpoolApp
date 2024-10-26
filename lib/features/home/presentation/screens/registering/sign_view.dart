import 'package:carpool/features/home/presentation/screens/registering/signin.dart';
import 'package:carpool/features/home/presentation/screens/registering/signup.dart';
import 'package:carpool/features/home/presentation/widgets/signappbar.dart';
import 'package:flutter/material.dart';

class SignningView extends StatelessWidget {
  const SignningView({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 8.0, right: 8.0, top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SignAppbar(),
                  const Row(
                    children: [
                      Text(
                        "Welcome to,\n ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/icons/logo.png",
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    textAlign: TextAlign.center,
                    "Your ride, Your Choice",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignUp();
                              },
                            ));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SignIn();
                              },
                            ));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              width: 2.5,
                              color: Colors.blueAccent,
                            ),
                            foregroundColor: Colors.blue,
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
