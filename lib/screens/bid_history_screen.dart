import 'package:flutter/material.dart';

class BidHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _bids = [
    {'amount': 50000, 'date': '2023-10-01', 'status': 'Approved'},
    {'amount': 30000, 'date': '2023-09-15', 'status': 'Pending'},
    {'amount': 45000, 'date': '2023-09-10', 'status': 'Rejected'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการเสนอราคา'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        itemCount: _bids.length,
        itemBuilder: (context, index) {
          final bid = _bids[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.monetization_on,
                color: Colors.green.shade700,
              ),
              title: Text(
                '฿${bid['amount']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Date: ${bid['date']}'),
              trailing: Text(
                bid['status'],
                style: TextStyle(
                  color:
                      bid['status'] == 'Approved'
                          ? Colors.green
                          : bid['status'] == 'Rejected'
                          ? Colors.red
                          : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
