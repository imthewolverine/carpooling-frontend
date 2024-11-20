import 'package:carpooling_frontend/models/driver.dart';
import 'package:carpooling_frontend/models/request.dart';
import 'package:carpooling_frontend/screens/request_profile_screen/request_profile_screen.dart';
import 'package:flutter/material.dart';

final driver = Driver(
  id: "driver123",
  driverName: "driverAdmin",
  email: "batlhagva15@gmail.com",
  firstName: "batlkhagva",
  lastName: "battulga",
  password: "123",
  phoneNumber: "90553609",
);

class RequestCard extends StatelessWidget {
  final Request request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestProfileScreen(
                driver: driver,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          title: Text(
            "${request.driverFirstName} ${request.driverLastName}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: Colors.yellow),
              Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return Text(
                    '4.5 ҮНЭЛГЭЭ',
                    style:
                        theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
