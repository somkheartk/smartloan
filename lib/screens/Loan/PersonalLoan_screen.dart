import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:smartloan/Widgets/bottom_nav_items.dart';
import 'package:smartloan/screens/History/history_screen.dart';
import 'package:smartloan/screens/home/home_screen.dart';
import 'package:smartloan/screens/settings_screen.dart';

class PersonalLoanScreen extends StatefulWidget {
  @override
  _PersonalLoanScreenState createState() => _PersonalLoanScreenState();
}

class _PersonalLoanScreenState extends State<PersonalLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'th',
    symbol: '฿',
  );
  bool _isLoading = false;

  double _loanAmount = 0;
  double _interestRate = 0;
  int _loanTerm = 0;
  List<Map<String, dynamic>> _schedule = [];
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreenContent(),
    HistoryScreen(), // Replace Placeholder with Bid History Screen
    SettingsScreen(), // Replace with Settings Screen
  ];

  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();

  void _calculateLoanSchedule() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      _loanAmount = double.parse(
        _loanAmountController.text.replaceAll(',', ''),
      );
      _interestRate = double.parse(
        _interestRateController.text.replaceAll(',', ''),
      );
      _loanTerm = int.parse(_loanTermController.text.replaceAll(',', ''));

      final monthlyInterestRate = _interestRate / 12 / 100;
      final numberOfPayments = _loanTerm * 12;

      final monthlyPayment =
          monthlyInterestRate == 0
              ? _loanAmount / numberOfPayments
              : _loanAmount *
                  monthlyInterestRate /
                  (1 - pow(1 + monthlyInterestRate, -numberOfPayments));

      double balance = _loanAmount;
      _schedule = [];

      for (int month = 1; month <= numberOfPayments; month++) {
        final interest = balance * monthlyInterestRate;
        final principal = monthlyPayment - interest;
        balance -= principal;

        _schedule.add({
          'month': month,
          'principal': principal,
          'interest': interest,
          'total': monthlyPayment,
          'balance': balance > 0 ? balance : 0,
        });
      }

      setState(() => _isLoading = false);
    } else {
      _showSnackBar('กรุณากรอกข้อมูลให้ครบถ้วน', Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('เครื่องคิดเลขสินเชื่อ', style: GoogleFonts.kanit()),
            backgroundColor: Colors.teal,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    label: 'ยอดเงินกู้ (บาท)',
                    controller: _loanAmountController,
                    validatorMsg: 'กรุณากรอกยอดเงินกู้',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'อัตราดอกเบี้ยต่อปี (%)',
                    controller: _interestRateController,
                    validatorMsg: 'กรุณากรอกอัตราดอกเบี้ย',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'ระยะเวลากู้ (ปี)',
                    controller: _loanTermController,
                    validatorMsg: 'กรุณากรอกระยะเวลากู้',
                  ),
                  const SizedBox(height: 20),
                  _buildButtons(),
                  const SizedBox(height: 30),
                  if (_schedule.isNotEmpty) _buildScheduleTable(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: bottomNavItems, // Use the constant from the new file
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.kanit(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text.replaceAll(',', '');
          final formattedText = NumberFormat(
            '#,##0.##',
          ).format(double.tryParse(text) ?? 0);
          return TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: formattedText.length),
          );
        }),
      ],
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            double.tryParse(value.replaceAll(',', '')) == null ||
            double.parse(value.replaceAll(',', '')) <= 0) {
          return validatorMsg;
        }
        return null;
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('คำนวณ', Colors.teal, _calculateLoanSchedule),
        _buildActionButton('ล้างข้อมูล', Colors.redAccent, () {
          _loanAmountController.clear();
          _interestRateController.clear();
          _loanTermController.clear();
          setState(() => _schedule = []);
        }),
        _buildActionButton('เสนอราคา', Colors.blueAccent, _showLoanSummary),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: GoogleFonts.kanit(fontSize: 16, color: Colors.white),
      ),
    );
  }

  void _showLoanSummary() {
    if (_schedule.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('สรุปรายละเอียดสินเชื่อ', style: GoogleFonts.kanit()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ยอดเงินกู้: ${_currencyFormat.format(_loanAmount)}',
                    style: GoogleFonts.kanit(),
                  ),
                  Text(
                    'อัตราดอกเบี้ย: $_interestRate%',
                    style: GoogleFonts.kanit(),
                  ),
                  Text(
                    'ระยะเวลากู้: $_loanTerm ปี',
                    style: GoogleFonts.kanit(),
                  ),
                  Text(
                    'ยอดผ่อนต่อเดือน: ${_currencyFormat.format(_schedule.first['total'])}',
                    style: GoogleFonts.kanit(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ปิด', style: GoogleFonts.kanit()),
                ),
              ],
            ),
      );
    } else {
      _showSnackBar('กรุณาคำนวณตารางการผ่อนชำระก่อน', Colors.orange);
    }
  }

  Widget _buildScheduleTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          _buildColumn('เดือน'),
          _buildColumn('เงินต้น'),
          _buildColumn('ดอกเบี้ย'),
          _buildColumn('รวม'),
          _buildColumn('ยอดคงเหลือ'),
        ],
        rows:
            _schedule.map((data) {
              return DataRow(
                cells: [
                  _buildCell(data['month']),
                  _buildCell(_currencyFormat.format(data['principal'])),
                  _buildCell(_currencyFormat.format(data['interest'])),
                  _buildCell(_currencyFormat.format(data['total'])),
                  _buildCell(_currencyFormat.format(data['balance'])),
                ],
              );
            }).toList(),
      ),
    );
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      label: Text(label, style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
    );
  }

  DataCell _buildCell(dynamic value) {
    return DataCell(Text(value.toString(), style: GoogleFonts.kanit()));
  }
}
