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
  '08:15 AM',
  '09:15 AM',
  '10:15 AM',
  '11:15 AM',
  '12:15 PM',
  '13:15 PM',
  '14:15 PM',
  '15:15 PM',
  '16:15 PM',
  'Customize Arrival Time', // Add custom option
];
double tripPrice = 0.0; // Initialize trip price with 0.0 EGP
double tripDistance = 0.0; // Variable to store the distance

String googleApiKey = "AIzaSyDSGQI3H998QCVc63a8SdV0cFikSJJ3AbE";
