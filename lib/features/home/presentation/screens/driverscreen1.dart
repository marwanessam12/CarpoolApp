import 'package:carpool/features/home/data/driver_model.dart';
import 'package:carpool/features/home/presentation/widgets/Driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//validated
class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              child: Form(
                key: _formKey,
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
                        child: TextFormField(
                          controller: drivercontroller.car_type,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Car type',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Car type',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter car type';
                            }
                            return null;
                          },
                        ),
                      ), // Car type
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextFormField(
                          controller: drivercontroller.car_model,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Model',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Model',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter model';
                            }
                            return null;
                          },
                        ),
                      ), // Model
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: drivercontroller.car_year,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Year',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Model year',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter car year';
                            }
                            if (int.tryParse(value) == null) {
                              return '*Please enter a valid year';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextFormField(
                          controller: drivercontroller.car_color,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Colour',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Car Colour',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter car colour';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: drivercontroller.car_letters,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Letters',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Car plates letters',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter car letters';
                            }
                            return null;
                          },
                        ),
                      ), // Car letters
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextFormField(
                          controller: drivercontroller.car_numbers,
                          onChanged: (value) {
                            setState(() {
                              _formKey.currentState!
                                  .validate(); // Manually trigger validation
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Numbers',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            hintText: 'Car plates Numbers',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter car numbers';
                            }
                            if (int.tryParse(value) == null) {
                              return '*Please enter valid numbers';
                            }
                            return null;
                          },
                        ),
                      ), // Car numbers
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: drivercontroller.nationalID,
                    onChanged: (value) {
                      setState(() {
                        _formKey.currentState!
                            .validate(); // Manually trigger validation
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'National ID number',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'Enter your national ID number',
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Please enter your national ID';
                      }
                      if (int.tryParse(value) == null) {
                        return '*Please enter a valid national ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: drivercontroller.license,
                    onChanged: (value) {
                      setState(() {
                        _formKey.currentState!
                            .validate(); // Manually trigger validation
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'License',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      hintText: 'License',
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Please enter your license';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final driver = DriverModel(
                            car_type: drivercontroller.car_type.text.trim(),
                            car_model: drivercontroller.car_model.text.trim(),
                            car_year: int.parse(
                                drivercontroller.car_year.text.trim()),
                            car_color: drivercontroller.car_color.text.trim(),
                            car_letters:
                                drivercontroller.car_letters.text.trim(),
                            car_numbers: int.parse(
                                drivercontroller.car_numbers.text.trim()),
                            nationalID: int.parse(
                                drivercontroller.nationalID.text.trim()),
                            license: drivercontroller.license.text.trim(),
                          );
                          DriverController.instance.createUser(driver);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
