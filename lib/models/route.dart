import 'package:cloud_firestore/cloud_firestore.dart';

class RouteModel {
  final String id;
  final String description;
  final String driverId;
  final GeoPoint startLocation;
  final GeoPoint endLocation;
  final Timestamp startTime;
  final String location;
  final String userId;

  RouteModel({
    required this.id,
    required this.description,
    required this.driverId,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    required this.location,
    required this.userId,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      driverId: map['driverId'] ?? '',
      startLocation: map['start_location'] ?? GeoPoint(0, 0),
      endLocation: map['end_location'] ?? GeoPoint(0, 0),
      startTime: map['startTime'] ?? Timestamp.now(),
      location: map['location'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
