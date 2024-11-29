import 'package:carpooling_frontend/models/DriverRequest.dart';
import 'package:carpooling_frontend/models/userRequest.dart';
import 'package:carpooling_frontend/widgets/request_card.dart';
import 'package:carpooling_frontend/widgets/user_request_card.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:carpooling_frontend/models/route.dart';

final List<DriverRequest> exampleRequests = [
  DriverRequest(
      driverFirstName: 'John', driverLastName: 'Doe', status: 'Pending'),
  DriverRequest(
      driverFirstName: 'Jane', driverLastName: 'Smith', status: 'Approved')
];
final List<UserRequest> exampleUserRequests = [
  UserRequest(userFirstName: 'John', userLastName: 'Doe', status: 'Pending'),
  UserRequest(userFirstName: 'Jane', userLastName: 'Smith', status: 'Approved')
];

class UserRouteDescriptionScreen extends StatelessWidget {
  final RouteModel route; // Example requests data

  const UserRouteDescriptionScreen({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Theme.of(context)
                                  .colorScheme
                                  .primary, // Text color of selected tab
                              unselectedLabelColor: Colors.grey,
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Indicator's color
                                  width: 2.0, // Thickness of the indicator
                                ), // Horizontal padding
                              ),
                              tabs: const [
                                Tab(text: "Route Info"),
                                Tab(text: "Requests"),
                              ],
                              indicatorColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _buildRouteInfo(
                                    context,
                                    route,
                                    formattedStartTime,
                                    startPoint,
                                    endPoint,
                                  ),
                                  _buildRequests(exampleRequests),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context, RouteModel route,
      String formattedStartTime, LatLng startPoint, LatLng endPoint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
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
                  _buildInfoCard(
                    "Start Time",
                    formattedStartTime,
                    Icons.access_time,
                    context,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequests(List<DriverRequest> requests) {
    return DefaultTabController(
      length: 2, // Two subtabs: "Pending" and "Approved"
      child: Column(
        children: [
          // Subtabs
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: "Жолооч"),
              Tab(text: "Эцэг, эх"),
            ],
          ),
          // Subtab content
          Expanded(
            child: TabBarView(
              children: [
                // Pending Requests
                _buildDriverRequestList(
                  requests.where((r) => r.status == 'Pending').toList(),
                  "No pending requests.",
                ),
                // Approved Requests
                _buildUserRequestList(
                  requests.where((r) => r.status == 'Approved').toList(),
                  "No approved requests.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverRequestList(
      List<DriverRequest> requests, String emptyMessage) {
    if (requests.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return RequestCard(
          request: request,
        );
      },
    );
  }

  Widget _buildUserRequestList(
      List<DriverRequest> requests, String emptyMessage) {
    if (requests.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return UserRequestCard(
          request: request,
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
}
