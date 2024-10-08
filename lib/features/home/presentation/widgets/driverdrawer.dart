import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/homescreen1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

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
            currentAccountPicture: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png',
                  ),
                ),
                const SizedBox(
                    width: 10), // Add some spacing between picture and rating
                RatingBar.builder(
                  initialRating: 0.0, // Default rating value
                  minRating: 1,
                  direction: Axis.horizontal,

                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20.0, // Adjust size as needed
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating); // Update the rating if needed
                  },
                ),
              ],
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
