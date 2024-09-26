import 'package:flutter/material.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Row(
                      children: [
                        Expanded(
                          child: TextField(
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
                    const Row(
                      children: [
                        Expanded(
                          child: TextField(
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
                          child: const TextField(
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
                            decoration: const InputDecoration(
                              labelText: 'letters',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'letters',
                            ),
                          ),
                        ), //first name
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: ' Numbers',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              hintText: 'Numbers',
                            ),
                          ),
                        ), //last name
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const TextField(
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
                    const TextField(
                      keyboardType: TextInputType.number,
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
                        onPressed: () {},
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
