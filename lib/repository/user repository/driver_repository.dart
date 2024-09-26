import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/data/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverRepository extends GetxController {
  static DriverRepository get instance => Get.find();
  final _db1 = FirebaseFirestore.instance;
  createUser(DriverModel driver) async {
    await _db1
        .collection("Drivers")
        .doc(userId)
        .set(driver.toJson1())
        .whenComplete(
          () => Get.snackbar("Success", "your account has been created.",
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
