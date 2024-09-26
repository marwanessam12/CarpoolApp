import 'package:carpool/features/home/data/driver_model.dart';
import 'package:carpool/features/home/data/user_model.dart';
import 'package:carpool/repository/user%20repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../repository/user repository/driver_repository.dart';

class DriverController extends GetxController {
  static DriverController get instance => Get.find();

  //Text fields controllers
  final car_type = TextEditingController();
  final car_model = TextEditingController();
  final car_color = TextEditingController();
  final car_year = TextEditingController();
  final license = TextEditingController();
  final nationalID = TextEditingController();
  final car_numbers = TextEditingController();
  final car_letters = TextEditingController();
  final driverRepo = Get.put(DriverRepository());

  void createUser(DriverModel driver) {
    driverRepo.createUser(driver);
  }
}
