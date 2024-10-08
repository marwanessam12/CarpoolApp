import 'package:flutter/material.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  int selectedSeats = 0; // To keep track of selected seats
  List<bool> seatSelected = [
    false,
    false,
    false
  ]; // To track the state of each seat
  String? selectedTime; // Variable to store the selected arrival time
  String?
      selectedDepartureTime; // Variable to store the selected departure time
  List<String> arrivalTimeOptions = [
    '--', // Placeholder option
    '8.15',
    '9.15',
    '10.15',
    '11.15',
    '12.15',
    '1.15',
    '2.15',
    '3.15',
    '4.15',
    'Customize Arrival Time', // Add custom option
  ];

  void _toggleSeat(int index) {
    // Allow selection only if less than 3 seats are selected or if the seat is already selected
    if (selectedSeats < 3 || seatSelected[index]) {
      setState(() {
        seatSelected[index] = !seatSelected[index]; // Toggle selection
        // Increment or decrement the selected seat count
        selectedSeats += seatSelected[index] ? 1 : -1;
      });
    }
  }

  // Function to open a dialog to select a custom arrival time
  Future<void> _selectCustomArrivalTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Format the picked time to the desired format
      String formattedTime =
          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        selectedTime = formattedTime; // Update the selected arrival time
        arrivalTimeOptions.add(formattedTime); // Add the custom time to options
      });
    }
  }

  // Function to open a dialog to select departure time
  Future<void> _selectDepartureTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Format the picked time to the desired format
      String formattedTime =
          '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        selectedDepartureTime =
            formattedTime; // Update the selected departure time
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
              style: TextStyle(
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center, // Center text horizontally
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'From',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    //controller:
                    decoration: const InputDecoration(
                      labelText: 'Starting location',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter departure location',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            // To Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'To',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(width: 35),
                Expanded(
                  child: TextFormField(
                    //controller:

                    decoration: const InputDecoration(
                      labelText: 'Arriving location',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter destination location',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            // Departure Time Row
            GestureDetector(
              onTap: () => _selectDepartureTime(
                  context), // Open time picker for dep time
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dep Time',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 10),
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

            // Arrival Time Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Arrival Time',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedTime, // Set the currently selected time
                  items: arrivalTimeOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value == 'Customize Arrival Time') {
                        _selectCustomArrivalTime(
                            context); // Open the custom time picker
                      } else {
                        selectedTime = value == '--'
                            ? null
                            : value; // Reset to null if '--' is selected
                      }
                    });
                  },
                  hint: const Text(
                    'Select time',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            // Seats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seats',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0), // Add right padding for spacing
                      child: GestureDetector(
                        onTap: () =>
                            _toggleSeat(index), // Toggle seat selection
                        child: Icon(
                          Icons.chair,
                          color: seatSelected[index]
                              ? Colors.blue
                              : Colors.grey, // Change color based on selection
                          size: 30, // Optional: increase icon size
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Create Trip Button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Handle create trip logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Create Trip',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
