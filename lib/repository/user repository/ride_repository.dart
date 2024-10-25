import 'package:carpool/features/home/data/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideRepository extends GetxController {
  static RideRepository get instance => Get.find();
  final _db2 = FirebaseFirestore.instance;
  createRide(RideModel ride) async {
    await _db2
        .collection("Ride")
        .get(ride.toJson2())
        .whenComplete(
          () => Get.snackbar("Success", "your ride has been created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }
}
