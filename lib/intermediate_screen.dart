import 'package:flutter/material.dart';
import 'package:smartloan/screens/home/home_screen.dart';
import 'screens/Login/login_screen.dart';
import 'services/auth_service.dart'; // Import the authentication service

class IntermediateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(), // Check login status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ), // Show loading indicator
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          // If logged in, navigate to HomeScreen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        } else {
          // If not logged in, navigate to LoginScreen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        }
        return Container(); // Return an empty container while navigating
      },
    );
  }
}
