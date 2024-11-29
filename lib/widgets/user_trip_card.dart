import 'package:carpooling_frontend/models/route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTripCard extends StatelessWidget {
  final RouteModel route;

  const UserTripCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    // Format the timestamp to a readable date and time
    final formattedStartTime =
        DateFormat('yyyy-MM-dd HH:mm').format(route.startTime.toDate());

    return Card(
      margin: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Placeholder
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.location_on, color: Colors.grey),
            ),
            const SizedBox(width: 12.0),
            // Ad Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display location
                  Text(
                    "Location: ${route.location}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5.0),
                  // Display start time
                  Text("Start Time: $formattedStartTime"),
                  // Display description
                  Text("Description: ${route.description}"),
                ],
              ),
            ),
            // Navigation Arrow Icon in Circle
            InkWell(
              onTap: () {
                //TripListScreen(
                //  startLocation: route.startLocation,
                //  endLocation: route.endLocation,
                //)
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF00204A),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
