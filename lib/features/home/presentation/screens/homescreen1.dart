import 'package:carpool/features/home/presentation/widgets/mapsnew.dart';
import 'package:carpool/features/home/presentation/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var MediaQuary = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            height: MediaQuary.height * 0.18,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.white),
            child: const Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Pickup Point',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    hintText: 'Enter Pickup Point',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Where to?',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    hintText: 'Where to?',
                  ),
                ),
              ],
            ),
          ),
          //hishamcarpooolupdate555
          Expanded(child: MapScreen()),
        ],
      ),
    );
  }
}