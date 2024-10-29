import 'package:intl/intl.dart';

//trip updated successfully to db
class RideModel {
  final String? selectedTime;
  final String? selectedDepartureTime;
  final DateTime? selectedDate;
  final int? selectedSeats;
  final double? tipPrice;
  final double? tripDistance;
  final String? originController;
  final String? destinationController;
  final String tripType;

  const RideModel({
    required this.selectedTime,
    required this.selectedDepartureTime,
    required this.selectedDate,
    required this.selectedSeats,
    required this.tipPrice,
    required this.tripDistance,
    required this.originController,
    required this.destinationController,
    required this.tripType,
  });
  Map<String, dynamic> toJson() {
    return {
      "Arrival Time": selectedTime != null
          ? DateFormat.jm().format(DateFormat("HH:mm").parse(selectedTime!))
          : null,
      "Departure Time": selectedDepartureTime != null
          ? DateFormat.jm()
              .format(DateFormat("HH:mm").parse(selectedDepartureTime!))
          : null,
      "Date": selectedDate != null
          ? DateFormat('dd-MM-yyyy').format(selectedDate!)
          : null,
      "Seats": selectedSeats,
      "Price(EGP)": double.parse(tipPrice!.toStringAsFixed(2)),
      "Trip Distance (km)": double.parse(tripDistance!.toStringAsFixed(2)),
      "Starting location": originController,
      "Arriving location": destinationController,
      "Mode": tripType,
    };
  }
}
