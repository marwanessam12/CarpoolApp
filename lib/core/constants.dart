String userEmail = '';
String userName = '';
String userId = '';

int selectedSeats = 0; // To keep track of selected seats
List<bool> seatSelected = [
  false,
  false,
  false
]; // To track the state of each seat
String? selectedTime; // Variable to store the selected arrival time
String? selectedDepartureTime; // Variable to store the selected departure time
DateTime selectedDate = DateTime.now(); // Initialize with today's date
List<String> arrivalTimeOptions = [
  '--', // Placeholder option
  '8.15',
  '9.15',
  '10.15',
  '11.15',
  '12.15',
  '13.15',
  '14.15',
  '15.15',
  '16.15',
  'Customize Arrival Time', // Add custom option
];
double tripPrice = 0.0; // Initialize trip price with 0.0 EGP
double tripDistance = 0.0; // Variable to store the distance

String googleApiKey = "AIzaSyDSGQI3H998QCVc63a8SdV0cFikSJJ3AbE";
