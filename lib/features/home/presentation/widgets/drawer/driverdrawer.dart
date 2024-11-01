import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/user/homescreen1.dart';
import 'package:carpool/features/home/presentation/widgets/nav_widgets/driverhistory.dart';
import 'package:carpool/features/home/presentation/widgets/nav_widgets/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData) {
                final userData = snapshot.data;
                return DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png',
                            ),
                            radius: 30,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['first name'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userData?['email'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 30,
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text('No data available'),
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
                      title: const Text('Your rides'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HistoryScreen(
                              driverId: userId,
                            );
                          },
                        ));
                      },
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
                    child: const Text("Passenger mode"),
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
