import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey.shade700,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('Profile'),
            onTap: () {
              // Navigate to Profile Settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to Notification Settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.red),
            title: Text('Privacy & Security'),
            onTap: () {
              // Navigate to Privacy Settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text('About'),
            onTap: () {
              // Navigate to About Page
            },
          ),
        ],
      ),
    );
  }
}
