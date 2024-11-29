import 'package:carpooling_frontend/models/route.dart';
import 'package:carpooling_frontend/widgets/trip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final exampleTrips = [
  RouteModel(
    id: '1',
    location: 'Ulaanbaatar',
    description: 'Ongoing Route',
    driverId: 'driver123',
    startLocation: GeoPoint(47.9184, 106.9170),
    endLocation: GeoPoint(47.920538, 106.933446),
    startTime: Timestamp.fromDate(DateTime.parse('2022-01-01 12:00:00')),
    userId: 'user123',
  ),
  RouteModel(
    id: '2',
    location: 'Ulaanbaatar',
    description: 'Ongoing Route 2',
    driverId: 'driver123',
    startLocation: GeoPoint(47.9184, 106.9170),
    endLocation: GeoPoint(47.920538, 106.933446),
    startTime: Timestamp.fromDate(DateTime.parse('2022-01-02 14:00:00')),
    userId: 'user124',
  ),
];

class TripListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip List'),
      ),
      body: ListView.builder(
        itemCount: exampleTrips.length,
        itemBuilder: (context, index) {
          final trip = exampleTrips[index];
          return TripCard(route: trip);
        },
      ),
    );
  }
}
