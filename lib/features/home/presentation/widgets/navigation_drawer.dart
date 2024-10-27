import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/driver/driverhomescreen.dart';
import 'package:carpool/features/home/presentation/screens/driver/driverscreen1.dart';
import 'package:carpool/features/home/presentation/widgets/nav_widgets/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  Future<void> _checkDriverMode(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Now check if this userId exists in the driver collection
      final userDriver =
          await firestore.collection('Drivers').doc(userId).get();

      if (userDriver.exists) {
        // Navigate to DriverHomeScreen if the document exists in driver collection
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const DriverHome();
          },
        ));
      } else {
        // Handle case where no user with userid is found
        print('No driver found with id: $userId');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return DriverScreen();
          },
        ));
      }
    } catch (e) {
      // Handle errors here (e.g., show an error message)
      print('Error checking driver mode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            accountName: Text(userName ?? ''),
            accountEmail: Text(userEmail ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text('My Trips'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Payment'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Help'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Messages'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Safety Center'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SettingsScreen();
                          },
                        ));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 6, left: 6),
                  child: TextButton(
                    onPressed: () => _checkDriverMode(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Driver mode"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
