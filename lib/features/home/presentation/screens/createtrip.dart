import 'dart:math';

import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/data/ride_model.dart';
import 'package:carpool/features/home/presentation/screens/driverhomescreen.dart';
import 'package:carpool/features/home/presentation/widgets/created_successfully.dart';
import 'package:carpool/features/home/presentation/widgets/ride_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart'; // For formatting the date

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSwitched = false;

  // Method to calculate distance in kilometers
  double _calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371.0; // Radius of the Earth in km
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Method to calculate price based on distance
  void _calculatePrice() {
    if (_origin != null && _destination != null) {
      double distance = _calculateDistance(_origin!, _destination!);
      setState(() {
        tripDistance = distance; // Set trip distance
        tripPrice = distance * 2; // 2 EGP per km
      });
    }
  }

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

  GoogleMapController? mapController;
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey:
          "AIzaSyDSGQI3H998QCVc63a8SdV0cFikSJJ3AbE"); // Replace with your API Key
  List<Prediction> _originPredictions = [];
  List<Prediction> _destinationPredictions = [];
  LatLng? _origin;
  LatLng? _destination;
  List<LatLng> _routeCoordinates = []; // To hold the route coordinates

  void _onSearchChanged(String query, bool isOrigin) async {
    if (query.isEmpty) {
      setState(() {
        isOrigin ? _originPredictions.clear() : _destinationPredictions.clear();
      });
      return;
    }

    final result = await _places.autocomplete(query,
        components: [Component(Component.country, "EG")]); // Limit to Egypt

    if (result.isOkay) {
      setState(() {
        if (isOrigin) {
          _originPredictions = result.predictions;
        } else {
          _destinationPredictions = result.predictions;
        }
      });
    } else {
      print("Error: ${result.errorMessage}");
    }
  }

  void _onPlaceSelected(Prediction prediction, bool isOrigin) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);
    LatLng location = LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    setState(() {
      if (isOrigin) {
        _origin = location;
        originController.text = prediction.description!;
        _originPredictions.clear();
      } else {
        _destination = location;
        destinationController.text = prediction.description!;
        _destinationPredictions.clear();
      }
      _calculatePrice();
    });
  }

  List<LatLng> _decodePoly(String poly) {
    List<LatLng> polyline = [];
    var numPoints = poly.length;
    var index = 0;
    while (index < numPoints) {
      var lat = 0;
      var lng = 0;
      int b;
      do {
        b = poly.codeUnitAt(index++) - 63;
        lat |= (b & 0x1f) << 5;
      } while (b >= 0x20);
      lat = ((lat & 1) != 0 ? ~(lat >> 1) : (lat >> 1));
      do {
        b = poly.codeUnitAt(index++) - 63;
        lng |= (b & 0x1f) << 5;
      } while (b >= 0x20);
      lng = ((lng & 1) != 0 ? ~(lng >> 1) : (lng >> 1));
      polyline.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return polyline;
  }

  void _onMapTapped(LatLng tappedPosition) {
    setState(() {
      if (_origin == null) {
        _origin = tappedPosition;
        originController.text =
            "Selected Location: (${tappedPosition.latitude}, ${tappedPosition.longitude})"; // Optional description
      } else if (_destination == null) {
        _destination = tappedPosition;
        destinationController.text =
            "Selected Location: (${tappedPosition.latitude}, ${tappedPosition.longitude})"; // Optional description
      }
    });
  }

  @override

  Widget build(BuildContext context) {
    final ridecontroller= Get.put(RideController());
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
                  child: TextField(

                    controller: ridecontroller.originController,

                    decoration: const InputDecoration(
                      labelText: 'Starting location',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Pickup point',
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                    onChanged: (value) {
                      _onSearchChanged(value, true);
                      setState(() {
                        _formKey.currentState!
                            .validate(); // Manually trigger validation
                      });
                    },
                  ),
                ),
              ],
            ),

            if (_originPredictions.isNotEmpty)
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: _originPredictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_originPredictions[index].description!),
                      onTap: () =>
                          _onPlaceSelected(_originPredictions[index], true),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('To', style: TextStyle(fontSize: 18.0)),
                const SizedBox(width: 35),
                Expanded(
                  child: TextField(
                    controller: ridecontroller.destinationController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Arriving location',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      _onSearchChanged(value, false);
                    },
                  ),
                ),
              ],
            ),
            if (_destinationPredictions.isNotEmpty)
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: _destinationPredictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_destinationPredictions[index].description!),
                      onTap: () => _onPlaceSelected(
                          _destinationPredictions[index], false),
                    );
                  },
                ),
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
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
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
                  'Kilometer',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  '${tripDistance.toStringAsFixed(2)} km', // Display trip distance
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
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
                  '${tripPrice.toStringAsFixed(2)} EGP', // Display trip price
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
                  if (_formKey.currentState!.validate()) {
                    final ride = RideModel(
                      Starting_location: ridecontroller.originController.text.trim(),
                      Arriving_location: ridecontroller.destinationController.text.trim(),

                    );
                    RideController.instance.createRide(ride);
                  }
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const CreatedSuccessfully();
                    },
                  ));

                  // After 5 seconds, navigate to DriverHomeScreen
                  Future.delayed(const Duration(seconds: 10), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverHome()),
                    );
                  });
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
