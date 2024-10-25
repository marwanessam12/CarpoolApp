import 'package:carpool/features/home/data/ride_model.dart';
import 'package:carpool/repository/user%20repository/ride_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideController extends GetxController {
  static RideController get instance => Get.find();

  //Text fields controllers
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final rideRepo = Get.put(RideRepository());

  void createRide(RideModel ride) {
    rideRepo.createRide(ride);
  }
}
