import 'package:carpool/features/home/data/ride_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideRepository extends GetxController {
  static RideRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance; // Renamed for clarity

  // Create a new ride in Firestore
  Future<void> createRide(RideModel ride) async {
    try {
      await _db.collection("Ride").add(ride.toJson()).then((value) {
        // Show success message when ride is created
        Get.snackbar(
          "Success",
          "Your ride has been created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      });
    } catch (error) {
      // Handle errors gracefully
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Error creating ride: ${error.toString()}");
    }
  }
}
