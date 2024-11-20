import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling_frontend/models/route.dart';
import 'package:carpooling_frontend/widgets/route_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile_screen/profile_screen.dart';
import '../add_post_screen/add_post_screen.dart';
import '../home_screen/home_bloc.dart';
import '../home_screen/home_event.dart';
import '../home_screen/home_state.dart';

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
    location: 'Darkhan',
    description: 'Another Route',
    driverId: 'driver456',
    startLocation: GeoPoint(49.0335, 105.9678),
    endLocation: GeoPoint(49.0358, 105.9760),
    startTime: Timestamp.fromDate(DateTime.parse('2022-02-01 15:00:00')),
    userId: 'user456',
  ),
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadAds()),
      child: DefaultTabController(
        length: 2, // Two tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF6F6F6),
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
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                Expanded(
                  child: _buildSearchSection(context),
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Add notification navigation logic here
                  },
                ),
              ],
            ),
            bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Оруулсан маршрут'),
                Tab(text: 'Зөвшөөрсөн маршрут'),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: TabBarView(
            children: [
              // First tab: Routes
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return _buildAdList(context, exampleRoutes);
                  } else if (state is HomeError) {
                    return _buildAdList(context, exampleRoutes);
                    //return Center(
                    //  child: Text(
                    //    'Failed to load routes.',
                    //    style: TextStyle(color: Colors.red),
                    //  ),
                    //);
                  } else {
                    return Center(
                      child: Text(
                        'No routes available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
              // Second tab: Favorites
              Center(
                child: Text(
                  'Favorites coming soon!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 30,
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _showAddPostBottomSheet(context);
                  },
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  void _showAddPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: AddPostScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Хайх...',
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.black),
        ),
        onChanged: (query) {
          context.read<HomeBloc>().add(SearchAds(query));
        },
      ),
    );
  }

  Widget _buildAdList(BuildContext context, List<RouteModel> routes) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return RouteCard(route: route);
      },
    );
  }
}
