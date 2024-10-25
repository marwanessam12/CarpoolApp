class RideModel {
  // final String selectedTime;
  // final String selectedDepartureTime;
  // final String selectedDate;
  // final String selectedSeats;
  // final double tipPrice;
  // final double tripDistance;
  final String originController;
  final String destinationController;





  const RideModel({
    // required this.selectedTime,
    // required this.selectedDepartureTime,
    // required this.selectedDate,
    // required this.selectedSeats,
    // required this.tipPrice,
    // required this.tripDistance,
    required this.originController,
    required this.destinationController,
  });
  toJson2() {
    return {
      // "Arrival_Time": selectedTime,
      // "Departure_Time": selectedDepartureTime,
      // "Date": selectedDate,
      // "Seats": selectedSeats,
      // "Price": tipPrice,
      // "Trip_Distance": tripDistance,
      "Starting_location": originController,
      "Arriving_location": destinationController,
    };
  }
}
