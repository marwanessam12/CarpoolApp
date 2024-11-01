import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final String? driverId; // Assuming you pass driverID to this screen

  HistoryScreen({required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Ride')
            .where('Driver id', isEqualTo: driverId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              var date = trip['Date'];
              var departureTime = trip['Departure Time'];
              var startingLocation = trip['Starting location'];
              var arrivingLocation = trip['Arriving location'];
              var price = trip['Price(EGP)'];

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        Text('$date, $departureTime',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('$price EGP',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.green, size: 10),
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
                        const Icon(Icons.circle, color: Colors.blue, size: 10),
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
