import 'package:flutter/material.dart';

class SubmitBidScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _loanTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit New Bid'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(labelText: 'Customer Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the customer name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _loanTypeController,
                    decoration: InputDecoration(labelText: 'Loan Type'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the loan type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle bid submission logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bid Submitted Successfully')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the home screen
              },
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
