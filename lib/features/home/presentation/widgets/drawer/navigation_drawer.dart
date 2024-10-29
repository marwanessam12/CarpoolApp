import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/driver/driverhomescreen.dart';
import 'package:carpool/features/home/presentation/screens/driver/driverscreen1.dart';
import 'package:carpool/features/home/presentation/widgets/nav_widgets/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data();
      } else {
        print("User not found in the 'users' collection");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> _checkDriverMode(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final userDriver =
          await firestore.collection('Drivers').doc(userId).get();

      if (userDriver.exists) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const DriverHome();
          },
        ));
      } else {
        print('No driver found with id: $userId');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return DriverScreen();
          },
        ));
      }
    } catch (e) {
      print('Error checking driver mode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  accountName: Text('Loading...'),
                  accountEmail: Text('Loading...'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png'),
                  ),
                );
              } else if (snapshot.hasData) {
                final userData = snapshot.data;
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  accountName: Text(
                    userData?['first name'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(userData?['email'] ?? ''),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png'),
                  ),
                );
              } else {
                return const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  accountName: Text('No data'),
                  accountEmail: Text('No data'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png'),
                  ),
                );
              }
            },
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
