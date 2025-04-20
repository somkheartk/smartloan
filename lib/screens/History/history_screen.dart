import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Loan/submit_bid_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _BidHistoryScreenState createState() => _BidHistoryScreenState();
}

class _BidHistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _bids = [
    {
      'amount': 50000,
      'date': '2023-10-01',
      'status': 'Approved',
      'customerName': 'John Doe',
      'phone': '123-456-7890',
      'loanType': 'Personal Loan',
    },
    {
      'amount': 30000,
      'date': '2023-09-15',
      'status': 'Pending',
      'customerName': 'Jane Smith',
      'phone': '987-654-3210',
      'loanType': 'Car Loan',
    },
    {
      'amount': 45000,
      'date': '2023-09-10',
      'status': 'Rejected',
      'customerName': 'Alice Johnson',
      'phone': '555-666-7777',
      'loanType': 'Home Loan',
    },
  ];

  String _searchKeyword = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> get _filteredBids {
    return _bids.where((bid) {
      final matchesKeyword =
          _searchKeyword.isEmpty ||
          bid['customerName'].toLowerCase().contains(
            _searchKeyword.toLowerCase(),
          ) ||
          bid['phone'].contains(_searchKeyword) ||
          bid['loanType'].toLowerCase().contains(_searchKeyword.toLowerCase());
      final matchesDate =
          (_startDate == null ||
              DateTime.parse(bid['date']).isAfter(_startDate!)) &&
          (_endDate == null || DateTime.parse(bid['date']).isBefore(_endDate!));
      return matchesKeyword && matchesDate;
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการเสนอราคา'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmitBidScreen()),
                  );
                },
                child: Text('Submit New Bid'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Already on the bid history screen, no action needed
                },
                child: Text('View History'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the home screen
                },
                child: Text('Home'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by keyword',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _startDate == null
                      ? 'Start Date: Not selected'
                      : 'Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate!)}',
                ),
                Text(
                  _endDate == null
                      ? 'End Date: Not selected'
                      : 'End Date: ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
                ),
                TextButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text('Select Date Range'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBids.length,
              itemBuilder: (context, index) {
                final bid = _filteredBids[index];
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${bid['date']}'),
                        Text('Customer: ${bid['customerName'] ?? 'Unknown'}'),
                        Text('Phone: ${bid['phone'] ?? 'N/A'}'),
                        Text('Loan Type: ${bid['loanType'] ?? 'N/A'}'),
                      ],
                    ),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Bid Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Amount: ฿${bid['amount']}'),
                                  Text('Date: ${bid['date']}'),
                                  Text('Status: ${bid['status']}'),
                                  Text(
                                    'Customer: ${bid['customerName'] ?? 'Unknown'}',
                                  ),
                                  Text('Phone: ${bid['phone'] ?? 'N/A'}'),
                                  Text(
                                    'Loan Type: ${bid['loanType'] ?? 'N/A'}',
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
