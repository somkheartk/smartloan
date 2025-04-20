import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartloan/screens/History/history_screen.dart';
import 'package:smartloan/screens/Loan/PersonalLoan_screen.dart';
import 'package:smartloan/screens/settings_screen.dart';
import 'intermediate_screen.dart';
import 'Cores/config/language.dart'; // Import the language configuration

void main() => runApp(LoanCalculatorApp());

class LoanCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Language.appTitle, // Use text from language config
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE3F2FD),
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),

      home: IntermediateScreen(),
    );
  }
}
