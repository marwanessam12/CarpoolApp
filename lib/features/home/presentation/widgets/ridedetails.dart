import 'package:carpool/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RideDetailsScreen extends StatelessWidget {
  final String rideId; // Pass the ride ID to fetch the specific ride
  final String? driverId; // Pass the driver ID to fetch the specific driver

  RideDetailsScreen({required this.rideId, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Ride Details")),
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
                  .doc(userId)
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
                                  onPressed: () {
                                    // Handle booking logic
                                  },
                                  child: const Text(
                                    "Book Ride",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
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
