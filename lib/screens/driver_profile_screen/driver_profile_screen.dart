import 'package:flutter/material.dart';
import 'package:carpooling_frontend/models/driver.dart';

class DriverProfileScreen extends StatelessWidget {
  final Driver driver;

  const DriverProfileScreen({Key? key, required this.driver}) : super(key: key);

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
                  "${driver.firstName} ${driver.lastName}",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Bottom Section - White background
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 16),

                  // Description and Registration Date
                  // Buttons to navigate to Driver Info and Vehicle Info
                  ListTile(
                    title: Text(
                      'Driver Information',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: theme.colorScheme.onSurface),
                    onTap: () {
                      // Navigate to Driver Information screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      'Vehicle Information',
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
                    'Driver Details',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow("Phone Number", driver.phoneNumber, theme),
                  _buildDetailRow("Driver Name", driver.driverName, theme),
                  _buildDetailRow("Email", driver.email, theme),
                  const SizedBox(height: 16),

                  // Recent Routes Section
                  _buildSectionHeader('Recent Routes', theme),
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
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 16,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route Name',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
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
