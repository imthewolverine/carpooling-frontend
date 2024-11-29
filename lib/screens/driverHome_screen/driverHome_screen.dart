import 'package:carpooling_frontend/models/driver.dart';
import 'package:carpooling_frontend/screens/driver_profile_screen/driver_profile_screen.dart';
import 'package:carpooling_frontend/widgets/driver_route_card.dart';
import 'package:carpooling_frontend/widgets/trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling_frontend/models/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driverHome_bloc.dart';
import 'driverHome_event.dart';
import 'driverHome_state.dart';

final driver = Driver(
  id: "driver123",
  driverName: "driverAdmin",
  email: "batlhagva15@gmail.com",
  firstName: "batlkhagva",
  lastName: "battulga",
  password: "123",
  phoneNumber: "90553609",
);

List<RouteModel> exampleRoutes = [
  RouteModel(
    id: '1',
    location: 'Ulaanbaatar',
    description: 'Description',
    driverId: 'driver123',
    startLocation: GeoPoint(47.9184, 106.9170),
    endLocation: GeoPoint(47.920538, 106.933446),
    startTime: Timestamp.fromDate(DateTime.parse('2022-01-01 12:00:00')),
    userId: 'user123',
  ),
  RouteModel(
    id: '2',
    location: 'Ulaanbaatar',
    description: 'Another Route',
    driverId: 'driver123',
    startLocation: GeoPoint(47.9184, 106.9170),
    endLocation: GeoPoint(47.920538, 106.933446),
    startTime: Timestamp.fromDate(DateTime.parse('2022-01-01 12:00:00')),
    userId: 'user123',
  ),
];

class DriverHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverHomeBloc()..add(LoadAds()),
      child: DefaultTabController(
        length: 2, // Two tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            title: Row(
              children: [
                IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSxSycPmZ67xN1lxHxyMYOUPxZObOxnkLf6w&s',
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverProfileScreen(
                                driver: driver,
                              )),
                    );
                  },
                ),
                Expanded(
                  child: _buildSearchSection(context),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Add notification navigation logic here
                  },
                ),
              ],
            ),
            bottom: const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Маршрут'),
                Tab(text: 'Эхэлсэн маршрут'),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: TabBarView(
            children: [
              // First tab: Routes
              BlocBuilder<DriverHomeBloc, DriverHomeState>(
                builder: (context, state) {
                  if (state is DriverHomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DriverHomeLoaded) {
                    return _buildRouteList(context, exampleRoutes);
                  } else if (state is DriverHomeError) {
                    return _buildRouteList(context, exampleRoutes);
                  } else {
                    return Center(
                      child: Text(
                        'No routes available.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
              // Second tab: Trips
              _buildTripList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
        ),
        onChanged: (query) {
          context.read<DriverHomeBloc>().add(SearchAds(query));
        },
      ),
    );
  }

  Widget _buildRouteList(BuildContext context, List<RouteModel> routes) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return DriverRouteCard(route: route);
      },
    );
  }

  Widget _buildTripList(BuildContext context) {
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

    return ListView.builder(
      itemCount: exampleTrips.length,
      itemBuilder: (context, index) {
        final trip = exampleTrips[index];
        return TripCard(route: trip);
      },
    );
  }
}
