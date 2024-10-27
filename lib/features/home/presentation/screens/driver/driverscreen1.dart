import 'dart:io';

import 'package:carpool/core/constants.dart';
import 'package:carpool/features/home/data/driver_model.dart';
import 'package:carpool/features/home/presentation/screens/driver/driverhomescreen.dart';
import 'package:carpool/features/home/presentation/widgets/controllers/Driver_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String imageUrl = '';
  // bool driverImageUploaded = false; // Track if the image is uploaded
  // bool carImageUploaded = false; // Track if the image is uploaded
  //
  File? _DriverLicense;
  File? _CarLicense;
  final ImagePicker _picker = ImagePicker();

  // Function to pick image
  Future<void> _pickImage1() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _DriverLicense = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _CarLicense = File(pickedFile.path);
      });
    }
  }

// Function to upload image to Firebase Storage
  Future<String> _uploadImageToStorage(File image, String fileName) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$userId/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

// Function to upload images to Firebase Storage and store URLs in Firestore
  Future<void> _registerNow() async {
    if (_DriverLicense != null && _CarLicense != null) {
      try {
        // Upload driver license image with custom name
        String imageUrl1 = await _uploadImageToStorage(
            _DriverLicense!, 'driver_license_image');

        // Upload car license image with custom name
        String imageUrl2 =
            await _uploadImageToStorage(_CarLicense!, 'car_license_image');

        // Save the URLs to Firestore
        await FirebaseFirestore.instance.collection('Drivers').add({
          'driverLicenseUrl': imageUrl1,
          'carLicenseUrl': imageUrl2,
        });
      } catch (e) {}
    }
  }

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
                  const SizedBox(height: 10.0),
                  OutlinedButton(
                    onPressed: _pickImage1,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Rounded corners
                      ),
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      side: BorderSide(
                        color: _DriverLicense != null
                            ? Colors.green
                            : Colors.grey[700]!, // Change border color
                      ),
                      foregroundColor: _DriverLicense != null
                          ? Colors.green
                          : Colors.grey[700]!,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _DriverLicense != null
                              ? 'Driver license uploaded successfully'
                              : 'Upload Driver license image',
                        ),
                        Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DriverLicense != null
                      ? Image.file(_DriverLicense!, height: 100, width: 100)
                      : const Text('No image selected'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _pickImage2,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // Rounded corners
                      ),
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      side: BorderSide(
                        color: _CarLicense != null
                            ? Colors.green
                            : Colors.grey[700]!, // Change border color
                      ),
                      foregroundColor: _CarLicense != null
                          ? Colors.green
                          : Colors.grey[700]!,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _CarLicense != null
                              ? 'Car license uploaded successfully'
                              : 'Upload Car license image',
                        ),
                        Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _CarLicense != null
                      ? Image.file(_CarLicense!, height: 100, width: 100)
                      : const Text('No image selected'),
                  const SizedBox(height: 15.0),
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _registerNow(); // Call the _registerNow method to handle image uploads and Firestore entry

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

                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return DriverHome();
                              },
                            ));
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
                      )),
                ]),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
