import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/driverscreen1.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

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
                      onTap: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 6, left: 6),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const DriverScreen();
                        },
                      ));
                    },
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
