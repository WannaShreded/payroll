import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';
import '../services/employee_service.dart';
import '../widgets/employee_card.dart';
import 'employee_form_page.dart';
import 'employee_detail_page.dart';

class EmployeePage extends StatefulWidget {
  final UserModel user;

  const EmployeePage({super.key, required this.user});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  List<EmployeeModel> _allEmployees = [];
  List<EmployeeModel> _filteredEmployees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    final employees = await EmployeeService.getAllEmployees();
    setState(() {
      _allEmployees = employees;
      _filteredEmployees = employees;
      _isLoading = false;
    });
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEmployees = _allEmployees.where((emp) {
        return emp.fullName.toLowerCase().contains(query) ||
            emp.position.toLowerCase().contains(query) ||
            emp.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addEmployee() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const EmployeeFormPage()),
    );
    if (result == true) {
      _loadEmployees();
    }
  }

  void _viewEmployee(EmployeeModel employee) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EmployeeDetailPage(employee: employee)),
    );
    if (result == true) {
      _loadEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Karyawan'),
        backgroundColor: AppColors.primaryGradientStart,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGradientStart,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari karyawan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Employee List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEmployees.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = _filteredEmployees[index];
                          return EmployeeCard(
                            employee: employee,
                            onTap: () => _viewEmployee(employee),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: AppColors.primaryGradientStart,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Belum ada karyawan'
                : 'Karyawan tidak ditemukan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          if (_searchController.text.isEmpty)
            Text(
              'Tap + untuk menambah karyawan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
        ],
      ),
    );
  }
}
