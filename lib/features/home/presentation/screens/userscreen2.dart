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
                width: double.infinity,
                height: mediaQuary.height * 0.20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Outline color
                    width: 2.0, // Outline width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corners (optional)
                ),
                padding: EdgeInsets.all(16.0), // Inner padding (optional)
                child: Text("to be done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
