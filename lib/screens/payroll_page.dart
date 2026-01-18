import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';
import '../services/employee_service.dart';
import '../services/payroll_service.dart';
import '../services/attendance_service.dart';
import '../widgets/salary_slip.dart';
import '../widgets/app_shell.dart';

class PayrollPage extends StatefulWidget {
  final UserModel user;

  const PayrollPage({super.key, required this.user});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  List<EmployeeModel> _employees = [];
  bool _isLoading = true;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    final employees = await EmployeeService.getAllEmployees();

    // Generate sample attendance data for each employee
    for (var emp in employees) {
      await AttendanceService.generateSampleAttendance(emp.id);
    }

    setState(() {
      _employees = employees;
      _isLoading = false;
    });
  }

  Future<void> _viewSalarySlip(EmployeeModel employee) async {
    // Calculate payroll
    try {
      setState(() => _isLoading = true);

      final payroll = await PayrollService.calculatePayroll(
        employee,
        _selectedMonth,
        _selectedYear,
      );

      // Save payroll record
      await PayrollService.savePayroll(payroll);

      if (mounted) {
        setState(() => _isLoading = false);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            builder: (context, scrollController) =>
                SalarySlip(payroll: payroll, employee: employee),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      user: widget.user,
      currentIndex: 2,
      appBar: AppBar(
        title: const Text('Penggajian'),
        backgroundColor: AppColors.primaryGradientStart,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month/Year Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryGradientStart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Periode',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getMonthName(_selectedMonth)} $_selectedYear',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedMonth == 1) {
                            _selectedMonth = 12;
                            _selectedYear--;
                          } else {
                            _selectedMonth--;
                          }
                        });
                      },
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedMonth == 12) {
                            _selectedMonth = 1;
                            _selectedYear++;
                          } else {
                            _selectedMonth++;
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Employee List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _employees.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      final employee = _employees[index];
                      return _buildEmployeeCard(employee);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeModel employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryGradientStart,
                AppColors.primaryGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              employee.getInitials(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          employee.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(employee.position),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _viewSalarySlip(employee),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada karyawan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan karyawan di menu Data Karyawan',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return monthNames[month - 1];
  }
}
