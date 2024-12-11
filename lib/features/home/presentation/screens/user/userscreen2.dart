import 'package:carpool/features/home/data/ride_model.dart';
import 'package:carpool/features/home/presentation/widgets/app_bars/app_bar.dart';
import 'package:carpool/features/home/presentation/widgets/ridedetails.dart';
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
      driverId: doc['Driver id'],
      selectedTime: doc['Arrival Time'],
      selectedDepartureTime: doc['Departure Time'],
      selectedDate: doc['Date'] != null
          ? DateFormat('dd.MM.yyyy').parse(doc['Date'])
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
      appBar: MyAppBar(),
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 120,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "No trips available",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "NUGO has no rides matching your request. Please request one.",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Display the bottom sheet when "Request Ride" is clicked
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        int selectedHour = 0;
                        int selectedMinute = 0;
                        String selectedPeriod = "AM";

                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Select Arrival Time:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Hour picker
                                        Expanded(
                                          child:
                                              ListWheelScrollView.useDelegate(
                                            itemExtent: 50,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedHour = index + 1;
                                              });
                                            },
                                            physics: FixedExtentScrollPhysics(),
                                            childDelegate:
                                                ListWheelChildBuilderDelegate(
                                              builder: (context, index) {
                                                return Center(
                                                  child: Text(
                                                    (index + 1)
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                );
                                              },
                                              childCount: 12,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        // Minute picker
                                        Expanded(
                                          child:
                                              ListWheelScrollView.useDelegate(
                                            itemExtent: 50,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedMinute = index;
                                              });
                                            },
                                            physics: FixedExtentScrollPhysics(),
                                            childDelegate:
                                                ListWheelChildBuilderDelegate(
                                              builder: (context, index) {
                                                return Center(
                                                  child: Text(
                                                    index
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                );
                                              },
                                              childCount: 60,
                                            ),
                                          ),
                                        ),
                                        // AM/PM picker
                                        Expanded(
                                          child:
                                              ListWheelScrollView.useDelegate(
                                            itemExtent: 50,
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedPeriod =
                                                    index == 0 ? "AM" : "PM";
                                              });
                                            },
                                            physics: FixedExtentScrollPhysics(),
                                            childDelegate:
                                                ListWheelChildListDelegate(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "AM",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    "PM",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        print(
                                            "Selected Time: ${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod");
                                      },
                                      child: const Text("Confirm Request"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: const Text("Request Ride"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              RideModel ride = _fromFirestore(doc);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideDetailsScreen(
                          rideId: doc.id,
                          driverId: ride.driverId, // Pass the driver ID
                        ),
                      ),
                    );
                  },
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
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: _buildSeatIcons(ride.selectedSeats ?? 0),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
