import 'dart:io';

import 'package:carpooling_frontend/models/userRequest.dart';
import 'package:carpooling_frontend/models/user_model.dart';
import 'package:carpooling_frontend/screens/user_request_profile_screen/user_request_profile_screen.dart';
import 'package:flutter/material.dart';

User user = User(
  username: 'schoolPolice123',
  firstName: 'Alice',
  lastName: 'Johnson',
  email: 'alice.johnson@schoolpolice.com',
  phoneNumber: 1234567890,
  password: 'securePassword123',
  image: File('/path/to/alice_profile_image.png'), // Replace with actual path
  assignedSchools: ['Greenwood High School', 'Central Elementary School'],
);

class UserRequestCard extends StatelessWidget {
  final UserRequest request;

  const UserRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserRequestProfileScreen(
                user: user,
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
            "${request.userFirstName} ${request.userLastName}",
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
