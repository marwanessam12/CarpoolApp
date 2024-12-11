class DriverModel {
  final String car_color;
  final String car_model;
  final int car_year;
  final String car_type;
  final int nationalID;
  final String car_letters;
  final int car_numbers;

  const DriverModel({
    required this.car_type,
    required this.car_color,
    required this.car_model,
    required this.car_year,
    required this.nationalID,
    required this.car_letters,
    required this.car_numbers,
  });
  toJson1() {
    return {
      "car type": car_type,
      "car model": car_model,
      "car color": car_color,
      "car year": car_year,
      "national id": nationalID,
      "car plate numbers": car_numbers,
      "car plate letters": car_letters,
    };
  }
}
