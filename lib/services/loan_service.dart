import 'dart:math';

class LoanService {
  // This class will handle all the logic related to loans
  // For example, calculating interest, payment schedules, etc.

  double calculateInterest(double principal, double rate, int time) {
    return (principal * rate * time) / 100;
  }

  double calculateMonthlyPayment(double principal, double rate, int time) {
    double monthlyRate = rate / (12 * 100);
    int numberOfPayments = time * 12;
    return (principal * monthlyRate) /
        (1 - pow(1 + monthlyRate, -numberOfPayments));
  }
}
