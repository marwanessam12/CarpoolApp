import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/screens/user/homescreen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  final String rideId; // Pass the ride ID to fetch the specific ride
  final String? driverId; // Pass the driver ID to fetch the specific driver

  RideDetailsScreen({required this.rideId, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Your Rides")),
        body: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('Ride').doc(rideId).get(),
          builder: (context, rideSnapshot) {
            if (rideSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (rideSnapshot.hasError) {
              return Center(child: Text("Error: ${rideSnapshot.error}"));
            }
            if (!rideSnapshot.hasData || !rideSnapshot.data!.exists) {
              return const Center(child: Text("Ride not found"));
            }

            final rideData = rideSnapshot.data!.data() as Map<String, dynamic>?;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(driverId)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return Center(child: Text("Error: ${userSnapshot.error}"));
                }
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Center(child: Text("Driver not found"));
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Drivers')
                      .doc(driverId)
                      .get(),
                  builder: (context, driverSnapshot) {
                    if (driverSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (driverSnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${driverSnapshot.error}"));
                    }
                    if (!driverSnapshot.hasData ||
                        !driverSnapshot.data!.exists) {
                      return const Center(child: Text("Driver not found"));
                    }

                    final driverData =
                        driverSnapshot.data!.data() as Map<String, dynamic>?;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date Row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rideData?['Date'] ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),

                              // Price Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total price for 1 passenger ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    "${rideData?['Price(EGP)']} EGP",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // Departure and Starting Location Row
                              Row(
                                children: [
                                  Text(
                                    "${rideData?['Departure Time'] ?? 'N/A'}   ",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${rideData?['Starting location'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                              // Arrival Time and Location Row
                              Row(
                                children: [
                                  Text(
                                    "${rideData?['Arrival Time'] ?? 'N/A'}   ",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      " ${rideData?['Arriving location'] ?? 'N/A'}",
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),

                              // Driver Information Row
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        userData?['profileIconUrl'] ?? ''),
                                    radius: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    userData?['first name'] ?? 'Driver Name',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Contact Button
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Call: ${userData?['mobile number'] ?? 'N/A'}"),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.call_rounded,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Contact ${userData?['first name'] ?? 'N/A'}",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Seat Information
                              const Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Max, 2 in the back seats",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),

                              // Car Information
                              Row(
                                children: [
                                  Text("${driverData?['car model'] ?? 'N/A'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 10),
                                  Text("${driverData?['car year'] ?? 'N/A'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // License Plate Information
                              Text(
                                  " ${driverData?['car plate letters'] ?? 'N/A'} - ${driverData?['car plate numbers'] ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),

                              // Car Color Information
                              Text(" ${driverData?['car color'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                              const SizedBox(height: 30),
                            ],
                          ),

                          // Book Ride Button
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      // Fetch the current ride document
                                      DocumentSnapshot rideDoc =
                                          await FirebaseFirestore.instance
                                              .collection('Ride')
                                              .doc(rideId)
                                              .get();

                                      final rideData = rideDoc.data()
                                          as Map<String, dynamic>;
                                      final currentSeats =
                                          rideData['Seats'] ?? 0;

                                      // Check if seats are available
                                      if (currentSeats > 0) {
                                        Map<String, dynamic> updatedFields = {};

                                        // Retrieve existing passengers and add the current user
                                        String passengers =
                                            rideData['passengers'] ??
                                                ''; // Existing passenger IDs
                                        if (passengers.isNotEmpty) {
                                          passengers +=
                                              '/ $userId'; // Append new userId with a slash
                                        } else {
                                          passengers =
                                              userId!; // Initialize if no passengers yet
                                        }

                                        updatedFields['passengers'] =
                                            passengers; // Store all passenger IDs
                                        updatedFields['Seats'] = currentSeats -
                                            1; // Decrease available seats

                                        await FirebaseFirestore.instance
                                            .collection('Ride')
                                            .doc(rideId)
                                            .update(updatedFields);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Ride booked successfully!")),
                                        );
                                        Future.delayed(
                                            const Duration(seconds: 4), () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                            (Route<dynamic> route) => false,
                                          );
                                        });
                                      } else {
                                        // Show error dialog if no seats are available
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "No Seats Available"),
                                              content: const Text(
                                                  "There are no available seats for this ride."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Error booking ride: $e")),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    "Book Ride",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
