import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartloan/models/customer.dart';

class CustomerService {
  // This class will handle customer-related operations
  // such as fetching customer data, updating customer information, etc.

  // Example method to fetch customer data
  Future<List<Customer>> fetchCustomers() async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));
    return [Customer(id: 1, name: 'John Doe', email: 'john.doe@example.com')];
  }

  // Method to generate sample customer data
  List<Customer> generateSampleData() {
    return [
      Customer(id: 1, name: 'John Doe', email: 'john.doe@example.com'),
      Customer(id: 2, name: 'Jane Smith', email: 'jane.smith@example.com'),
      Customer(
        id: 3,
        name: 'Alice Johnson',
        email: 'alice.johnson@example.com',
      ),
      Customer(id: 4, name: 'Bob Brown', email: 'bob.brown@example.com'),
    ];
  }

  // Method to fetch customer data from an API
  Future<List<Customer>> getDataFromApi(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customer data from API');
    }
  }
}
