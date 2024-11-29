import 'package:flutter/material.dart';
import 'package:carpooling_frontend/models/driver.dart';

class RequestProfileScreen extends StatelessWidget {
  final Driver driver;

  const RequestProfileScreen({Key? key, required this.driver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Upper Half with primary color background (Driver Info)
          Container(
            color: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: theme.colorScheme.primary,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: theme.colorScheme.onPrimary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0, // Remove shadow from AppBar
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSxSycPmZ67xN1lxHxyMYOUPxZObOxnkLf6w&s',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${driver.driverName}",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('9 Хүргэлт',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.onPrimary)),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text(
                          '4.5 ҮНЭЛГЭЭ',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Section - White background
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      'Тээврийн хэрэгсэл',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: theme.colorScheme.onSurface),
                    onTap: () {
                      // Navigate to Vehicle Information screen
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Жолоочийн мэдээлэл',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow("Phone Number", driver.phoneNumber, theme),
                  _buildDetailRow("Жолоочийн нэр", driver.firstName, theme),
                  _buildDetailRow("Жолоочийн овог", driver.lastName, theme),
                  _buildDetailRow("Email", driver.email, theme),
                  const SizedBox(height: 16),

                  // Recent Routes Section
                  _buildSectionHeader('Өмнөх хүргэлтүүд', theme),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRouteCard(theme),
                        const SizedBox(width: 10),
                        _buildRouteCard(theme),
                        const SizedBox(width: 10),
                        _buildRouteCard(theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Implement the approval action
                print("Request Approved!");
              },
              child: const Text(
                "Зөвшөөрөх",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildRouteCard(ThemeData theme) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for the image
            child: Image.network(
              'https://img.lovepik.com/free-png/20210919/lovepik-school-png-image_400499294_wh1200.png', // Replace with the image URL
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover, // Ensures the image fits the container
            ),
          ),
          const SizedBox(height: 8), // Spacing between image and text
          // Text content
          Text(
            '3-р сургууль',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: 2024-07-07',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
