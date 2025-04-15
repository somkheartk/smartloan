import 'dart:math';
import 'package:flutter/material.dart';

class CarLoanScreen extends StatefulWidget {
  @override
  _CarLoanScreenState createState() => _CarLoanScreenState();
}

class _CarLoanScreenState extends State<CarLoanScreen> {
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();
  String _monthlyPayment = '';

  void _calculatePayment() {
    final double loanAmount = double.tryParse(_loanAmountController.text) ?? 0;
    final double interestRate =
        double.tryParse(_interestRateController.text) ?? 0;
    final int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

    if (loanAmount > 0 && interestRate > 0 && loanTerm > 0) {
      final double monthlyRate = interestRate / 100 / 12;
      final int totalMonths = loanTerm * 12;
      final double payment =
          loanAmount * monthlyRate / (1 - pow(1 + monthlyRate, -totalMonths));

      setState(() {
        _monthlyPayment = payment.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _monthlyPayment = 'กรุณากรอกข้อมูลให้ถูกต้อง';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('สินเชื่อรถ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
                children: [
                  TextField(
                    controller: _loanAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'จำนวนเงินกู้ (บาท)',
                    ),
                  ),
                  TextField(
                    controller: _interestRateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'อัตราดอกเบี้ย (%)'),
                  ),
                  TextField(
                    controller: _loanTermController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'ระยะเวลากู้ (ปี)'),
                  ),
                  ElevatedButton(
                    onPressed: _calculatePayment,
                    child: Text('คำนวณ'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ผลการคำนวณ: $_monthlyPayment บาท/เดือน',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
