import 'package:carpool/features/home/presentation/widgets/app_bars/app_bar.dart';
import 'package:carpool/features/home/presentation/widgets/history2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserHistoryScreen extends StatelessWidget {
  final String? passengerId;

  UserHistoryScreen({required this.passengerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'My Trips'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Ride').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data!.docs.where((trip) {
            var passengers = trip.data()['passengers'] as String? ?? '';
            return passengers.split('/ ').contains(passengerId);
          }).toList();

          if (trips.isEmpty) {
            return const Center(
              child: Text(
                'No previous trips ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              var rideId = trip.id; // Get the document ID for rideId
              var driverId =
                  trip.data()['Driver id'] ?? ''; // Safely get driverId
              var date = trip['Date'];
              var departureTime = trip['Departure Time'];
              var arrivalTime = trip['Arrival Time'];
              var startingLocation = trip['Starting location'];
              var arrivingLocation = trip['Arriving location'];
              var price = trip['Price(EGP)'];

              DateFormat format = DateFormat('dd.MM.yyyy h:mm a');
              String cleanedDate =
                  '$date $arrivalTime'.replaceAll(RegExp(r'\s+'), ' ');
              DateTime arrivalDateTime = format.parse(cleanedDate);

              bool isCompleted = DateTime.now().isAfter(arrivalDateTime);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => History2Screen(
                        rideId: rideId,
                        driverId: driverId,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$date, $departureTime',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('$price EGP',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                              Text(
                                isCompleted ? 'Completed' : 'Upcoming',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? Colors.grey
                                        : Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.green, size: 10),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              startingLocation,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.blue, size: 10),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              arrivingLocation,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
