import 'dart:convert';

import 'package:carpool/features/home/presentation/screens/userscreen2.dart';
import 'package:carpool/features/home/presentation/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey:
          "AIzaSyDSGQI3H998QCVc63a8SdV0cFikSJJ3AbE"); // Replace with your API Key
  List<Prediction> _originPredictions = [];
  List<Prediction> _destinationPredictions = [];
  LatLng? _origin;
  LatLng? _destination;
  List<LatLng> _routeCoordinates = []; // To hold the route coordinates

  void _onSearchChanged(String query, bool isOrigin) async {
    if (query.isEmpty) {
      setState(() {
        isOrigin ? _originPredictions.clear() : _destinationPredictions.clear();
      });
      return;
    }

    final result = await _places.autocomplete(query,
        components: [Component(Component.country, "EG")]); // Limit to Egypt

    if (result.isOkay) {
      setState(() {
        if (isOrigin) {
          _originPredictions = result.predictions;
        } else {
          _destinationPredictions = result.predictions;
        }
      });
    } else {
      print("Error: ${result.errorMessage}");
    }
  }

  void _onPlaceSelected(Prediction prediction, bool isOrigin) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);
    LatLng location = LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    setState(() {
      if (isOrigin) {
        _origin = location;
        _originController.text = prediction.description!;
        _originPredictions.clear();
      } else {
        _destination = location;
        _destinationController.text = prediction.description!;
        _destinationPredictions.clear();
      }
    });

    _showRouteOnMap();
  }

  void _showRouteOnMap() {
    if (_origin != null && _destination != null) {
      _getRouteCoordinates(); // Get the route when both points are set
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: _origin!, northeast: _destination!),
          100,
        ),
      );
    }
  }

  Future<void> _getRouteCoordinates() async {
    if (_origin != null && _destination != null) {
      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_origin!.latitude},${_origin!.longitude}&destination=${_destination!.latitude},${_destination!.longitude}&key=YOUR_GOOGLE_API_KEY'; // Replace with your API Key

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          _routeCoordinates.clear();
          for (var step in json['routes'][0]['legs'][0]['steps']) {
            var polyline = step['polyline']['points'];
            _routeCoordinates.addAll(_decodePoly(polyline));
          }

          setState(() {}); // Update the UI to show the polyline
        } else {
          print('Error fetching directions: ${json['status']}');
        }
      } else {
        print('Failed to get directions: ${response.statusCode}');
      }
    }
  }

  List<LatLng> _decodePoly(String poly) {
    List<LatLng> polyline = [];
    var numPoints = poly.length;
    var index = 0;
    while (index < numPoints) {
      var lat = 0;
      var lng = 0;
      int b;
      do {
        b = poly.codeUnitAt(index++) - 63;
        lat |= (b & 0x1f) << 5;
      } while (b >= 0x20);
      lat = ((lat & 1) != 0 ? ~(lat >> 1) : (lat >> 1));
      do {
        b = poly.codeUnitAt(index++) - 63;
        lng |= (b & 0x1f) << 5;
      } while (b >= 0x20);
      lng = ((lng & 1) != 0 ? ~(lng >> 1) : (lng >> 1));
      polyline.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return polyline;
  }

  void _onMapTapped(LatLng tappedPosition) {
    setState(() {
      if (_origin == null) {
        _origin = tappedPosition;
        _originController.text =
            "Selected Location: (${tappedPosition.latitude}, ${tappedPosition.longitude})"; // Optional description
      } else if (_destination == null) {
        _destination = tappedPosition;
        _destinationController.text =
            "Selected Location: (${tappedPosition.latitude}, ${tappedPosition.longitude})"; // Optional description
      }
      // Clear predictions when a location is selected on the map
      _originPredictions.clear();
      _destinationPredictions.clear();
    });

    // Call to show the route if both origin and destination are selected
    if (_origin != null && _destination != null) {
      _showRouteOnMap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _originController,
                      decoration: const InputDecoration(
                        labelText: 'Starting location',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        hintText: 'Enter Pickup point',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _onSearchChanged(value, true);
                      },
                    ),
                    if (_originPredictions.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          itemCount: _originPredictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(_originPredictions[index].description!),
                              onTap: () => _onPlaceSelected(
                                  _originPredictions[index], true),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Where to',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _onSearchChanged(value, false);
                      },
                    ),
                    if (_destinationPredictions.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          itemCount: _destinationPredictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  _destinationPredictions[index].description!),
                              onTap: () => _onPlaceSelected(
                                  _destinationPredictions[index], false),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(30.0444, 31.2357), // Cairo, Egypt
                    zoom: 10,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  onTap: _onMapTapped, // Listen for map taps
                  markers: {
                    if (_origin != null)
                      Marker(
                          markerId: MarkerId('origin'),
                          position: _origin!,
                          infoWindow:
                              InfoWindow(title: 'Origin', snippet: 'Selected')),
                    if (_destination != null)
                      Marker(
                          markerId: MarkerId('destination'),
                          position: _destination!,
                          infoWindow: InfoWindow(
                              title: 'Destination', snippet: 'Selected')),
                  },
                  polylines: {
                    if (_routeCoordinates.isNotEmpty)
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: _routeCoordinates,
                        color: Colors.blue,
                        width: 5,
                      ),
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 2,
            right: 2,
            child: Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FindingTrip();
                      },
                    ));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Find',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
