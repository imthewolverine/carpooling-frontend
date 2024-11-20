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
  List<LatLng> traveledRoute = []; // Явсан замыг хадгалах жагсаалт

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
    _listenToLocationUpdates();
  }

  // Хэрэглэгчийн анхны байршлыг олох
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
        _mapController.move(_currentLocation!, 15.0); // Газрын зургийг төвлөрүүлэх
      });
      print("Анхны байршил: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Байршил олоход алдаа гарлаа: $e");
    }
  }

  // Байршлыг бодит цаг хугацаанд шинэчлэх
  void _listenToLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

        if (_isTripStarted) {
          // Одоогийн байршлыг явсан замд нэмэх
          traveledRoute.add(_currentLocation!);
          _calculateTravelPercentage();
        }

        _checkProximity();
      });

      print("Шинэчлэгдсэн байршил: ${position.latitude}, ${position.longitude}");
    });
  }

  // Эхлэх болон дуусах байршлуудын ойролцоо эсэхийг шалгах
  void _checkProximity() {
    if (_currentLocation == null) return;

    const thresholdDistance = 50000; // Зайны босго (метрээр)

    final startDistance = Geolocator.distanceBetween(
      widget.startLocation.latitude,
      widget.startLocation.longitude,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

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

  // Явсан замын хувь хэмжээг тооцоолох
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
      traveledRoute = [_currentLocation!]; // Явсан замыг дахин эхлүүлэх
    });
    print("Явц эхэллээ: $_startTime");
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
          "Зарцуулагдсан хугацаа: ${elapsedTime.inMinutes} минут\nХувь хэмжээ: ${_travelPercentage.toStringAsFixed(1)}%",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ойлголоо"),
          ),
        ],
      ),
    );

    print("Явц дууслаа: $_endTime");
    print("Зарцуулагдсан хугацаа: $elapsedTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Явцын дэлгэрэнгүй'),
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
                    Polyline(
                      points: [widget.startLocation, widget.endLocation],
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
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
                  'Явцын хувь: ${_travelPercentage.toStringAsFixed(1)}%',
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
                      label: Text('Эхлүүлэх'),
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
