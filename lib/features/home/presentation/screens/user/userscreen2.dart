import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/presentation/widgets/controllers/ride_controller.dart';
import 'package:flutter/material.dart';

class FindingTrip extends StatelessWidget {
  const FindingTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
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
                            const Text(
                              'From',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(selectedDepartureTime!),
                          ],
                        ),
                        const SizedBox(width: 15),
                        const Icon(
                          Icons.location_on_sharp,
                          color: Colors.blue,
                        ),
                        Expanded(
                          child: Text(
                            RideController.originController.text,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'EGP ${tripPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0), // Space between rows
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            const SizedBox(width: 22),
                            const Icon(
                              Icons.location_on_sharp,
                              color: Colors.blue,
                            ),
                            Expanded(
                              child: Text(
                                RideController.destinationController.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        //add driver details for //text"user name ,icon avatar, seats"
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
