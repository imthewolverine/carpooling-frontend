import 'package:carpooling_frontend/models/route.dart';
import 'package:carpooling_frontend/screens/driverHome_screen/driverHome_bloc.dart';
import 'package:carpooling_frontend/screens/driverHome_screen/driverHome_event.dart';
import 'package:carpooling_frontend/screens/driverHome_screen/driverHome_state.dart';
import 'package:carpooling_frontend/widgets/route_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile_screen/profile_screen.dart';
import '../add_post_screen/add_post_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverHomeBloc()..add(LoadAds()),
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
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<DriverHomeBloc, DriverHomeState>(
                builder: (context, state) {
                  if (state is DriverHomeLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DriverHomeLoaded) {
                    return _buildAdList(context, state.ads);
                  } else if (state is DriverHomeError) {
                    return Center(
                      child: Text(
                        'Failed to load ads: ${state.message}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No ads available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                },
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          context.read<DriverHomeBloc>().add(SearchAds(query));
        },
      ),
    );
  }

  Widget _buildAdBanner(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.network(imageUrl),
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
