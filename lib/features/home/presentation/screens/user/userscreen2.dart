import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/widgets/ride_controller.dart';
import 'package:flutter/material.dart';

class FindingTrip extends StatelessWidget {
  const FindingTrip({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuary = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
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
                            Text(
                              'From',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(selectedDepartureTime!),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.blue,
                                ),
                                Text(
                                  RideController.originController.text
                                      .split(',')
                                      .first,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\EGP ${tripPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0), // Space between rows
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(selectedTime!),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Icon(
                              Icons.location_on_sharp,
                              color: Colors.blue,
                            ),
                            Text(
                              RideController.destinationController.text
                                  .split(',')
                                  .first,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
