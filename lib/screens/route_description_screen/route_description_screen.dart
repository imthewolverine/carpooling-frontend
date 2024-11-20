import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carpooling_frontend/models/route.dart';

class RouteDescriptionScreen extends StatelessWidget {
  final RouteModel route;

  const RouteDescriptionScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    // Format the Firestore timestamp to a readable format
    final formattedStartTime =
        DateFormat('yyyy-MM-dd HH:mm').format(route.startTime.toDate());

    final LatLng startPoint = LatLng(
      route.startLocation.latitude,
      route.startLocation.longitude,
    );

    final LatLng endPoint = LatLng(
      route.endLocation.latitude,
      route.endLocation.longitude,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 50),
                // Profile Picture and Route Information
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/logo_noword.png'),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "User name",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // White Rectangle Content
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Location and Description
                                    Text(
                                      "Location: ${route.location}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Description: ${route.description}",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 20),
                                    // Start and End Locations
                                    _buildLocationRow(
                                        "Start Location",
                                        "${route.startLocation.latitude}, ${route.startLocation.longitude}",
                                        Icons.location_on),
                                    const SizedBox(height: 10),
                                    _buildLocationRow(
                                        "End Location",
                                        "${route.endLocation.latitude}, ${route.endLocation.longitude}",
                                        Icons.location_on_outlined),
                                    const SizedBox(height: 20),
                                    // Start Time
                                    _buildInfoCard(
                                      "Start Time",
                                      formattedStartTime,
                                      Icons.access_time,
                                      context,
                                    ),
                                    const SizedBox(height: 20),
                                    // Action Buttons
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildActionButton(
                                          context,
                                          label: "Холбогдох",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          icon: Icons.phone,
                                          onPressed: () {
                                            _launchPhoneDialer("90553609");
                                          },
                                        ),
                                        _buildActionButton(
                                          context,
                                          label: "Газрын зураг",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          icon: Icons.map,
                                          onPressed: () {
                                            showMap(
                                                context, startPoint, endPoint);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Хүсэлт илгээх Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                print("Request Sent!");
                              },
                              child: const Text(
                                "Хүсэлт илгээх",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Back Arrow
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMap(BuildContext context, LatLng start, LatLng end) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Route Map",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: start,
                    zoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: start,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                        Marker(
                          point: end,
                          builder: (ctx) => const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
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
      },
    );
  }

  Widget _buildLocationRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon,
            color: (icon == Icons.location_on) ? Colors.green : Colors.red),
        const SizedBox(width: 10),
        Text(
          "$label: $value",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String label, String value, IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required Color color,
      IconData? icon,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: icon != null
          ? Icon(icon, color: Colors.white)
          : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
    );
  }

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
