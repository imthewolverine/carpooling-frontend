import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TripScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;

  const TripScreen({
    Key? key,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  double _travelPercentage = 0.0;
  bool _isTripStarted = false;
  bool _isAtStartLocation = false;
  bool _isAtEndLocation = false;
  DateTime? _startTime;
  DateTime? _endTime;
  List<LatLng> traveledRoute = []; // List to store the traveled path

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
    _listenToLocationUpdates();
  }

  // Fetch the user's initial location
  void _fetchInitialLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Байршлын үйлчилгээ идэвхгүй байна.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Байршлын зөвшөөрөл олгогдоогүй байна.");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation!, 12.0); // Center map on location
      });
      print("Эхний байршил: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Байршил авахад алдаа гарлаа: $e");
    }
  }

  // Listen to location updates in real-time
  void _listenToLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

        if (_isTripStarted) {
          // Add current location to traveled route
          traveledRoute.add(_currentLocation!);
          _calculateTravelPercentage();
        }

        _checkProximity();
      });

      print("Шинэ байршил: ${position.latitude}, ${position.longitude}");
    });
  }

  // Check if the user is near the start or end location
  void _checkProximity() {
    if (_currentLocation == null) return;

    const thresholdDistance = 50000; // Threshold distance in meters

    // Check proximity to start location
    final startDistance = Geolocator.distanceBetween(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

    // Check proximity to end location
    final endDistance = Geolocator.distanceBetween(
      widget.endLocation.latitude,
      widget.endLocation.longitude,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

    setState(() {
      _isAtStartLocation = startDistance <= thresholdDistance;
      _isAtEndLocation = endDistance <= thresholdDistance;
    });
  }

  // Calculate the percentage of the route traveled
  void _calculateTravelPercentage() {
    if (_currentLocation == null) return;

    final totalDistance = Geolocator.distanceBetween(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
      widget.endLocation.latitude,
      widget.endLocation.longitude,
    );

    final traveledDistance = Geolocator.distanceBetween(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

    setState(() {
      _travelPercentage = (traveledDistance / totalDistance) * 100;
      if (_travelPercentage > 100.0) _travelPercentage = 100.0;
    });
  }

  void _startTrip() {
    setState(() {
      _isTripStarted = true;
      _startTime = DateTime.now();
      _travelPercentage = 0.0;
      traveledRoute = [_currentLocation!]; // Reset traveled route
    });
    print("Явц эхэлсэн: $_startTime");
  }

  void _endTrip() {
    setState(() {
      _isTripStarted = false;
      _endTime = DateTime.now();
    });

    final elapsedTime =
    _startTime != null ? _endTime!.difference(_startTime!) : Duration.zero;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Явц дууссан"),
        content: Text(
          "Зарцуулагдсан хугацаа: ${elapsedTime.inMinutes} минут\nДууссан хувь: ${_travelPercentage.toStringAsFixed(1)}%",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ойлголоо"),
          ),
        ],
      ),
    );

    print("Явц дууссан: $_endTime");
    print("Зарцуулагдсан хугацаа: $elapsedTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ажлын маршрут'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation ?? widget.startLocation,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    // Show the full route
                    Polyline(
                      points: [widget.startLocation, widget.endLocation],
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                    // Show the traveled route
                    Polyline(
                      points: traveledRoute,
                      color: Colors.green,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        builder: (ctx) => Image.asset(
                          'assets/images/car_icon.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Явц: ${_travelPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: !_isTripStarted && _isAtStartLocation
                          ? _startTrip
                          : null,
                      icon: Icon(Icons.play_arrow),
                      label: Text('Эхлэх'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isTripStarted && _isAtEndLocation
                          ? _endTrip
                          : null,
                      icon: Icon(Icons.stop),
                      label: Text('Дуусгах'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
