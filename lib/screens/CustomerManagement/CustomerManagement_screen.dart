import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomerManagementScreen extends StatefulWidget {
  @override
  _CustomerManagementScreenState createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final List<Map<String, String>> _customers = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'phone': '1234567890',
      'email': 'john@example.com',
    },
    {
      'firstName': 'Alice',
      'lastName': 'Smith',
      'phone': '0987654321',
      'email': 'alice@example.com',
    },
  ];

  final PanelController _panelController = PanelController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Map<String, String>? _editingCustomer;
  String _searchQuery = "";
  String _searchType = "name"; // Default search type

  void _updateSearchQuery(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  void _updateSearchType(String? type) {
    setState(() => _searchType = type ?? "name");
  }

  List<Map<String, String>> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    return _customers.where((c) {
      switch (_searchType) {
        case "name":
          final fullName = '${c['firstName']} ${c['lastName']}'.toLowerCase();
          return fullName.contains(_searchQuery);
        case "phone":
          return c['phone']!.contains(_searchQuery);
        case "email":
          return c['email']!.toLowerCase().contains(_searchQuery);
        default:
          return false;
      }
    }).toList();
  }

  void _openPanel({Map<String, String>? customer}) {
    setState(() {
      _editingCustomer = customer;
      _firstNameController.text = customer?['firstName'] ?? '';
      _lastNameController.text = customer?['lastName'] ?? '';
      _phoneController.text = customer?['phone'] ?? '';
      _emailController.text = customer?['email'] ?? '';
    });
    _panelController.open();
  }

  void _saveCustomer() {
    final customer = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    };
    if (customer.values.any((v) => v.isEmpty)) return;

    setState(() {
      if (_editingCustomer != null) {
        final index = _customers.indexOf(_editingCustomer!);
        _customers[index] = customer;
      } else {
        _customers.add(customer);
      }
      _editingCustomer = null;
    });

    _panelController.close();
  }

  void _deleteCustomer(Map<String, String> customer) {
    setState(() => _customers.remove(customer));
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, String> c) {
    return GestureDetector(
      onTap: () => _openPanel(customer: c),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${c['firstName']} ${c['lastName']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete')
                      _deleteCustomer(c);
                    else if (value == 'edit')
                      _openPanel(customer: c);
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              '📞 ${c['phone']}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            Text(
              '✉️ ${c['email']}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddEditPanel() {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          height: 5,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _editingCustomer != null ? 'Edit Customer' : 'Add Customer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildInputField("First Name", _firstNameController),
              _buildInputField("Last Name", _lastNameController),
              _buildInputField(
                "Phone",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildInputField(
                "Email",
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _saveCustomer,
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openPanel(),
        label: Text("Add Customer"),
        icon: Icon(Icons.person_add_alt_1),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage your customers easily',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: TextButton(
                      onPressed: () => _updateSearchType("ค้นหา"),
                      child: Text('search'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredCustomers.length,
                itemBuilder:
                    (_, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCustomerCard(_filteredCustomers[index]),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
