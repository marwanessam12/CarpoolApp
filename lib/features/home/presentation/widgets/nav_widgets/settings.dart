import 'package:carpool/features/home/presentation/screens/registering/sign_view.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              // Sign out the user
                              await FirebaseAuth.instance.signOut();

                              // Navigate to the Sign In View
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return SignningView(); // Ensure this is the correct import
                                },
                              ));
                            } catch (e) {
                              // Handle sign-out error (optional)
                              print('Sign out failed: $e');
                            }
                          },
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          icon: const Icon(Icons.exit_to_app,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
