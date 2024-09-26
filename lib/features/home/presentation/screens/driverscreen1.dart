import 'package:carpool/features/home/data/driver_model.dart';
import 'package:carpool/features/home/presentation/widgets/Driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drivercontroller = Get.put(DriverController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ), //arrow back
                  ],
                ),
                const Text(
                  "Register as driver",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_type,
                        decoration: const InputDecoration(
                          labelText: 'Car type',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Car type',
                        ),
                      ),
                    ), //first name
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_model,
                        decoration: const InputDecoration(
                          labelText: ' Model',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Model',
                        ),
                      ),
                    ), //last name
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_year,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Model year',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_color,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Colour',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'Car Colour',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_letters,
                        decoration: const InputDecoration(
                          labelText: 'letters',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'car plates letters',
                        ),
                      ),
                    ), //first name
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: drivercontroller.car_numbers,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: ' Numbers',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(),
                          hintText: 'carplates Numbers',
                        ),
                      ),
                    ), //last name
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: drivercontroller.nationalID,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'national ID number',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    hintText: 'enter your national id number',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: drivercontroller.license,
                  decoration: const InputDecoration(
                    labelText: 'license',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    hintText: 'license',
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: TextButton(
                    onPressed: () {
                      final driver = DriverModel(
                        car_type: drivercontroller.car_type.text.trim(),
                        car_model: drivercontroller.car_model.text.trim(),
                        car_year:
                            int.parse(drivercontroller.car_year.text.trim()),
                        car_color: drivercontroller.car_color.text.trim(),
                        car_letters: drivercontroller.car_letters.text.trim(),
                        car_numbers:
                            int.parse(drivercontroller.car_numbers.text.trim()),
                        nationalID:
                            int.parse(drivercontroller.nationalID.text.trim()),
                        license: drivercontroller.license.text.trim(),
                      );
                      DriverController.instance.createUser(driver);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Register now",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ]),
            ))
          ],
        ),
      ),
    );
  }
}
