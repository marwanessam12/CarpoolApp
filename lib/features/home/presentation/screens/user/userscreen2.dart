import 'package:carpool/features/home/data/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripListScreen extends StatelessWidget {
  final String startLocation;
  final String arrivalLocation;
  final CollectionReference ridesCollection =
      FirebaseFirestore.instance.collection('Ride');

  TripListScreen(
      {super.key, required this.startLocation, required this.arrivalLocation});

  RideModel _fromFirestore(DocumentSnapshot doc) {
    return RideModel(
      id: "Driver Id",
      selectedTime: doc['Arrival Time'],
      selectedDepartureTime: doc['Departure Time'],
      selectedDate: doc['Date'] != null
          ? DateFormat('dd-MM-yyyy').parse(doc['Date'])
          : null,
      selectedSeats: doc['Seats'],
      tipPrice: (doc['Price(EGP)'] as num).toDouble(),
      tripDistance: (doc['Trip Distance (km)'] as num).toDouble(),
      originController: doc['Starting location'],
      destinationController: doc['Arriving location'],
      tripType: doc['Mode'],
    );
  }

  List<Widget> _buildSeatIcons(int availableSeats) {
    List<Widget> seatIcons = [];
    for (int i = 0; i < 3; i++) {
      seatIcons.add(
        Icon(
          Icons.airline_seat_recline_normal,
          size: 20,
          color: i < availableSeats ? Colors.blue : Colors.grey,
        ),
      );
    }
    return seatIcons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ridesCollection
            .where('Starting location', isEqualTo: startLocation)
            .where('Arriving location', isEqualTo: arrivalLocation)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No trips available",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              RideModel ride = _fromFirestore(snapshot.data!.docs[index]);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 4, spreadRadius: 2)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // First Row
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text('From',
                              //     style:
                              //         TextStyle(fontWeight: FontWeight.bold)),
                              Text(ride.selectedDepartureTime ?? ''),
                            ],
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_sharp,
                              color: Colors.blue),
                          Expanded(
                            child: Text(
                              ride.originController ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                  ' ${ride.tipPrice?.toStringAsFixed(2) ?? ''} EGP',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ],
                      ),

                      // Seats Row

                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildSeatIcons(ride.selectedSeats ?? 0),
                      ),
                      // Second Row
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text('To',
                              //     style:
                              //         TextStyle(fontWeight: FontWeight.bold)),
                              Text(ride.selectedTime ?? ''),
                            ],
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_sharp,
                              color: Colors.blue),
                          Expanded(
                            child: Text(
                              ride.destinationController ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
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
