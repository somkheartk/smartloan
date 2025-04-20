import 'package:flutter/material.dart';
import 'package:smartloan/screens/CustomerManagement/CustomerManagement_screen.dart';
import 'package:smartloan/screens/Loan/CarLoan_screen.dart';
import 'package:smartloan/screens/Loan/HomeLoan_screen.dart';
import 'package:smartloan/screens/Loan/PersonalLoan_screen.dart';
import '../History/history_screen.dart'; // Import the Bid History Screen
import '../settings_screen.dart'; // Import the Settings Screen
import '../../widgets/bottom_nav_items.dart'; // Import the new file

class HomeScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreenContent(),
    HistoryScreen(), // Replace Placeholder with Bid History Screen
    SettingsScreen(), // Replace with Settings Screen
    CustomerManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: bottomNavItems, // Use the constant from the new file
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          color: const Color.fromARGB(255, 37, 99, 150),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 50,
                color: const Color.fromARGB(
                  255,
                  207,
                  198,
                  198,
                ).withOpacity(0.9),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartLoan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Manage your loans with ease',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _menuItems(context).length,
              itemBuilder: (context, index) {
                final item = _menuItems(context)[index];
                return _buildMenuBox(
                  context,
                  icon: item['icon'] as IconData,
                  color: item['color'] as Color,
                  label: item['label'] as String,
                  onTap: item['onTap'] as VoidCallback,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuBox(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _menuItems(BuildContext context) => [
    {
      'icon': Icons.attach_money,
      'color': Colors.green.shade700,
      'label': 'Personal Loan',
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalLoanScreen()),
        );
        // Navigate to Loan Products Screen
      },
    },
    {
      'icon': Icons.home,
      'color': Colors.blue.shade700,
      'label': 'Home Loan Calculator',
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeLoanScreen()),
        );
      },
    },
    {
      'icon': Icons.directions_car,
      'color': Colors.orange.shade700,
      'label': 'Car Loan Calculator',
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarLoanScreen()),
        );
      },
    },
    {
      'icon': Icons.people,
      'color': Colors.purple.shade700,
      'label': 'Customer Management',
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerManagementScreen()),
        );
      },
    },
  ];
}
