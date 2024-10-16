import 'package:carpool/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart'; // For Google Places Autocomplete
import 'package:intl/intl.dart'; // For formatting the date

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  bool _isSwitched = false;

  void _toggleSeat(int index) {
    if (selectedSeats < 3 || seatSelected[index]) {
      setState(() {
        seatSelected[index] = !seatSelected[index]; // Toggle selection
        selectedSeats += seatSelected[index] ? 1 : -1;
      });
    }
  }

  Future<void> _selectCustomArrivalTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime =
          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        selectedTime = formattedTime; // Update the selected arrival time
        arrivalTimeOptions.add(formattedTime); // Add the custom time to options
      });
    }
  }

  Future<void> _selectDepartureTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime =
          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        selectedDepartureTime =
            formattedTime; // Update the selected departure time
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Initialize with the current selected date
      firstDate: DateTime.now(), // No earlier date than today
      lastDate: DateTime(2100), // Some reasonable future date
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            const Text(
              'Add New Trip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 30.0,
              ),
            ),
            const Text(
              'Make sure from the data you entering while creating new trip',
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('From', style: TextStyle(fontSize: 18.0)),
                const SizedBox(width: 10),
                Expanded(
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: startLocationController,
                    googleAPIKey: googleApiKey,
                    inputDecoration: const InputDecoration(
                      labelText: 'Starting location',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter departure location',
                    ),
                    debounceTime:
                        800, // Adjust debounce time as per your preference
                    countries: const ["eg"], // Restrict search to Egypt
                    isLatLngRequired:
                        true, // If you need latitude and longitude
                    getPlaceDetailWithLatLng: (prediction) {
                      // Debugging prints
                      print("Place: ${prediction.description}");
                      print("Latitude: ${prediction.lat}");
                      print("Longitude: ${prediction.lng}");
                    },
                    itemClick: (prediction) {
                      setState(() {
                        startLocationController.text = prediction.description!;
                        startLocationController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('To', style: TextStyle(fontSize: 18.0)),
                const SizedBox(width: 35),
                Expanded(
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: arriveLocationController,
                    googleAPIKey: googleApiKey,
                    inputDecoration: const InputDecoration(
                      labelText: 'Arriving location',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter destination location',
                    ),
                    debounceTime: 800,
                    countries: const ["eg"], // Restrict search to Egypt
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction) {
                      print("Place: ${prediction.description}");
                      print("Latitude: ${prediction.lat}");
                      print("Longitude: ${prediction.lng}");
                    },
                    itemClick: (prediction) {
                      arriveLocationController.text = prediction.description!;
                      arriveLocationController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () => _selectDepartureTime(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Depature Time', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        selectedDepartureTime ?? 'Select departure time',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: selectedDepartureTime != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Arrival Time', style: TextStyle(fontSize: 18.0)),
                const SizedBox(width: 45.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedTime,
                        items: arrivalTimeOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Customize Arrival Time') {
                              _selectCustomArrivalTime(context);
                            } else {
                              selectedTime = value == '--' ? null : value;
                            }
                          });
                        },
                        hint: const Text(
                          'Select time',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () => _selectDate(context), // Open date picker
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trip Date', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Text(
                        DateFormat('dd-MM-yyyy')
                            .format(selectedDate), // Display formatted date
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Seats Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Seats', style: TextStyle(fontSize: 18.0)),
                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () => _toggleSeat(index),
                        child: Icon(
                          Icons.chair,
                          color:
                              seatSelected[index] ? Colors.blue : Colors.grey,
                          size: 30,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mode",
                  style: TextStyle(fontSize: 18),
                ),
                CupertinoSwitch(
                  value: _isSwitched,
                  activeColor: Colors.blue, // Set the active color to blue
                  onChanged: (bool value) {
                    setState(() {
                      _isSwitched = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Price Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price (EGP)',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  tripPrice.toStringAsFixed(2) + ' EGP',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Handle create trip logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Create Trip',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
