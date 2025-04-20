import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: NavigationConstants.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: NavigationConstants.historyLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: NavigationConstants.settingsLabel,
        ),
      ],
    );
  }
}

class NavigationConstants {
  static const String homeLabel = 'หน้าหลัก';
  static const String historyLabel = 'ประวัติการเสนอราคา';
  static const String settingsLabel = 'ตั้งค่า';
}
