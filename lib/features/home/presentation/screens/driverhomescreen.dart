import 'package:carpool/features/home/presentation/widgets/createtrip.dart';
import 'package:carpool/features/home/presentation/widgets/driverdrawer.dart';
import 'package:flutter/material.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const DriverDrawer(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return CreateTrip();
                            },
                          ));
                        },
                        label: const Text(
                          'Add Trip',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
