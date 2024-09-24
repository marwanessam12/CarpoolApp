import 'package:carpool/features/home/data/user_model.dart';
import 'package:carpool/repository/user%20repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //Text fields controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final mobileNumber = TextEditingController();
  final age = TextEditingController();
  final id = TextEditingController();
  final gender = TextEditingController();

  final userRepo = Get.put(UserRepository());

  void createUser(UserModel user) {
    userRepo.createUser(user);
  }
}
