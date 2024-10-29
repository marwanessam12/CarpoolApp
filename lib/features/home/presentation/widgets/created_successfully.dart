import 'package:carpool/features/home/presentation/widgets/drawer/driverdrawer.dart';
import 'package:flutter/material.dart';

class CreatedSuccessfully extends StatelessWidget {
  const CreatedSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DriverDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    "assets/icons/car.png",
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    textAlign: TextAlign.center,
                    "Confirmed! Your trip has been created successfully",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    textAlign: TextAlign.center,
                    "your trip will appear to users with the same location ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black54),
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.timelapse_rounded),
                  Text(
                    "You'll be redirected after 5 seconds",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
