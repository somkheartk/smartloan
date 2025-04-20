import 'package:flutter/material.dart';
import 'dart:math';

class CarLoanScreen extends StatefulWidget {
  @override
  State<CarLoanScreen> createState() => _CarLoanCalculatorScreenState();
}

class _CarLoanCalculatorScreenState extends State<CarLoanScreen> {
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _downPaymentController = TextEditingController();

  String _monthlyPayment = '';
  String _totalPayment = '';
  String _totalInterest = '';
  bool _isLoading = false; // Add loading state

  void _calculatePayment() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate processing delay

    final double loanAmount = double.tryParse(_loanAmountController.text) ?? 0;
    final double interestRate =
        double.tryParse(_interestRateController.text) ?? 0;
    final int loanTerm = int.tryParse(_loanTermController.text) ?? 0;
    final double downPayment =
        double.tryParse(_downPaymentController.text) ?? 0;

    final double financedAmount = loanAmount - downPayment;

    if (financedAmount > 0 && interestRate > 0 && loanTerm > 0) {
      final double monthlyRate = interestRate / 100 / 12;
      final int totalMonths = loanTerm * 12;
      final double payment =
          financedAmount *
          monthlyRate /
          (1 - pow(1 + monthlyRate, -totalMonths));
      final double totalPayment = payment * totalMonths;
      final double totalInterest = totalPayment - financedAmount;

      setState(() {
        _monthlyPayment = payment.toStringAsFixed(2);
        _totalPayment = totalPayment.toStringAsFixed(2);
        _totalInterest = totalInterest.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _monthlyPayment = 'กรุณากรอกข้อมูลให้ถูกต้อง';
        _totalPayment = '';
        _totalInterest = '';
      });
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  void _showQuotation() async {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    // Mock existing data in the system
    final String? existingEmail = null; // Replace with actual data lookup
    final String? existingPhone = null; // Replace with actual data lookup

    if (_monthlyPayment.isEmpty ||
        _monthlyPayment == 'กรุณากรอกข้อมูลให้ถูกต้อง') {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('ข้อผิดพลาด'),
              content: Text('กรุณาคำนวณก่อนสร้างใบเสนอราคา'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ตกลง'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate processing delay

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('กรอกข้อมูลสำหรับใบเสนอราคา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (existingEmail != null && existingPhone != null) ...[
                  Text('อีเมล: $existingEmail'),
                  Text('เบอร์โทรศัพท์: $existingPhone'),
                ] else ...[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'ชื่อ-นามสกุล'),
                  ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'อีเมล'),
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showQuotationDetails(
                    existingEmail ?? emailController.text,
                    existingPhone ?? phoneController.text,
                    nameController.text,
                  );
                },
                child: Text('ยืนยัน'),
              ),
            ],
          ),
    );
  }

  void _showQuotationDetails(String email, String phone, String name) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('ใบเสนอราคา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty) Text('ชื่อ-นามสกุล: $name'),
                Text('อีเมล: $email'),
                Text('เบอร์โทรศัพท์: $phone'),
                SizedBox(height: 10),
                Text('จำนวนเงินกู้: ${_loanAmountController.text} บาท'),
                Text('เงินดาวน์: ${_downPaymentController.text} บาท'),
                Text('อัตราดอกเบี้ย: ${_interestRateController.text} %'),
                Text('ระยะเวลากู้: ${_loanTermController.text} ปี'),
                SizedBox(height: 10),
                Text('ค่างวดต่อเดือน: $_monthlyPayment บาท/เดือน'),
                Text('ยอดชำระทั้งหมด: $_totalPayment บาท'),
                Text('ดอกเบี้ยรวม: $_totalInterest บาท'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              ),
            ],
          ),
    );
  }

  void _resetFields() {
    setState(() {
      _loanAmountController.clear();
      _interestRateController.clear();
      _loanTermController.clear();
      _downPaymentController.clear();
      _monthlyPayment = '';
      _totalPayment = '';
      _totalInterest = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Loan Calculator'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Stack(
        children: [
          Padding(
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
                        controller: _downPaymentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'เงินดาวน์ (บาท)',
                        ),
                      ),
                      TextField(
                        controller: _interestRateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'อัตราดอกเบี้ย (%)',
                        ),
                      ),
                      TextField(
                        controller: _loanTermController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'ระยะเวลากู้ (ปี)',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _calculatePayment,
                        child: Text('คำนวณ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showQuotation,
                        child: Text('สร้างใบเสนอราคา'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ), // เพิ่มระยะห่างระหว่าง GridView และ DataTable
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'รายการ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ผลลัพธ์',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('เงินดาวน์')),
                          DataCell(Text('${_downPaymentController.text} บาท')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('เงินต้น')),
                          DataCell(
                            Text(
                              '${(double.tryParse(_loanAmountController.text) ?? 0) - (double.tryParse(_downPaymentController.text) ?? 0)} บาท',
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('ค่างวดต่อเดือน')),
                          DataCell(Text('$_monthlyPayment บาท/เดือน')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('ยอดชำระทั้งหมด')),
                          DataCell(Text('$_totalPayment บาท')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('ดอกเบี้ยรวม')),
                          DataCell(Text('$_totalInterest บาท')),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // เพิ่มระยะห่างจากขอบล่างของหน้าจอ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _calculatePayment,
                      child: Text('คำนวณ'),
                    ),
                    ElevatedButton(
                      onPressed: _resetFields,
                      child: Text('รีเซ็ต'),
                    ),
                    ElevatedButton(
                      onPressed: _showQuotation,
                      child: Text('ใบเสนอราคา'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
