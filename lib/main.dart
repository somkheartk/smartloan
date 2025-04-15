import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() => runApp(LoanCalculatorApp());

class LoanCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'เครื่องคิดเลขสินเชื่อ',
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      home: LoanCalculatorScreen(),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _loanAmount = 0;
  double _interestRate = 0;
  int _loanTerm = 0;

  List<Map<String, dynamic>> _schedule = [];

  // NumberFormat สำหรับการจัดรูปแบบตัวเลข
  final NumberFormat _currencyFormat = NumberFormat('#,###.##');

  void _calculateLoanSchedule() {
    _schedule.clear();
    double balance = _loanAmount;
    int totalMonths = _loanTerm * 12;
    double monthlyPrincipal = _loanAmount / totalMonths;
    double monthlyRate = _interestRate / 100 / 12;

    for (int month = 1; month <= totalMonths; month++) {
      double interest = balance * monthlyRate;
      double payment = monthlyPrincipal + interest;

      _schedule.add({
        'month': month,
        'principal': monthlyPrincipal,
        'interest': interest,
        'total': payment,
        'balance': balance - monthlyPrincipal,
      });

      balance -= monthlyPrincipal;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เครื่องคิดเลขสินเชื่อ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'จำนวนเงินสินเชื่อ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.kanit(fontSize: 16),
                onChanged: (value) => _loanAmount = double.tryParse(value) ?? 0,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'อัตราดอกเบี้ย (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.kanit(fontSize: 16),
                onChanged:
                    (value) => _interestRate = double.tryParse(value) ?? 0,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ระยะเวลาเงินกู้ (ปี)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.kanit(fontSize: 16),
                onChanged: (value) => _loanTerm = int.tryParse(value) ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateLoanSchedule,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('คำนวณตารางการผ่อนชำระ'),
              ),
              SizedBox(height: 20),
              Divider(thickness: 2),
              Expanded(
                child:
                    _schedule.isEmpty
                        ? Center(
                          child: Text(
                            'ไม่มีข้อมูล',
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowHeight: 40,
                            dataRowHeight: 60,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'เดือน',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'เงินต้น',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ดอกเบี้ย',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ยอดชำระ',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ยอดคงเหลือ',
                                  style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                _schedule.map((row) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          row['month'].toString(),
                                          style: GoogleFonts.kanit(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _currencyFormat.format(
                                            row['principal'],
                                          ),
                                          style: GoogleFonts.kanit(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _currencyFormat.format(
                                            row['interest'],
                                          ),
                                          style: GoogleFonts.kanit(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _currencyFormat.format(row['total']),
                                          style: GoogleFonts.kanit(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _currencyFormat.format(
                                            row['balance'],
                                          ),
                                          style: GoogleFonts.kanit(),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
