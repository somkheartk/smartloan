import 'package:flutter/material.dart';

class HomeLoanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Loan Calculator'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Text(
          'Home Loan Calculator Screen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
