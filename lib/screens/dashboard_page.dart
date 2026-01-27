import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

import '../widgets/stat_card.dart';
import '../widgets/menu_grid_item.dart';
import 'employee_page.dart';
import 'payroll_page.dart';
import 'attendance_page.dart';
// profile_page import removed (handled via AppShell navigation)
import '../services/employee_service.dart';
import '../services/payroll_service.dart';
import '../widgets/app_shell.dart';

class DashboardPage extends StatefulWidget {
  final UserModel user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// _DummySearchDelegate removed — search UI was removed from the header.

class _DashboardPageState extends State<DashboardPage> {
  Future<Map<String, dynamic>> _fetchDashboardStats() async {
    // Get total employees
    final employees = await EmployeeService.getAllEmployees();
    final totalEmployees = employees.length;

    // Get payroll data for current month: sum payroll per employee to avoid duplicates
    final now = DateTime.now();
    double totalSalary = 0.0;

    for (final emp in employees) {
      try {
        final payroll = await PayrollService.getPayrollByMonth(
          emp.id,
          now.month,
          now.year,
        );
        if (payroll != null) {
          totalSalary += payroll.totalNetSalary.toDouble();
        } else {
          // fallback: use estimated salary for this employee
          totalSalary += emp.getEstimatedSalary().toDouble();
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error fetching payroll for ${emp.id}: $e');
        totalSalary += emp.getEstimatedSalary().toDouble();
      }
    }

    final String formattedSalary = _formatCurrency(totalSalary);

    return {'totalEmployees': totalEmployees, 'totalSalary': formattedSalary};
  }

  String _formatCurrency(double amount) {
    final s = amount.round().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    final formattedReversed = buffer.toString();
    final formatted = formattedReversed.split('').reversed.join('');
    return 'Rp $formatted';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildHomePage() {
    final hour = DateTime.now().hour;
    final greeting = GreetingMessage.getGreeting(hour);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with modern welcome card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(Colors.black, Colors.transparent, 0.92)!,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar with shadow
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.lerp(Colors.black, Colors.transparent, 0.92)!,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.blue,
                        child: Text(
                          widget.user.fullName.isNotEmpty
                              ? widget.user.fullName
                                    .split(' ')
                                    .map((s) => s.isNotEmpty ? s[0] : '')
                                    .take(2)
                                    .join()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Name + small stats chips
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.user.fullName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.user.role,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateTime.now().toLocal().toString().split(
                                  ' ',
                                )[0],
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Stats Cards
                FutureBuilder<Map<String, dynamic>>(
                  future: _fetchDashboardStats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: AppText.totalEmployees,
                              value: '-',
                              icon: Icons.people,
                              bgColor: AppColors.orange,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: AppText.totalSalary,
                              value: '-',
                              icon: Icons.attach_money,
                              bgColor: AppColors.success,
                            ),
                          ),
                        ],
                      );
                    }
                    final stats = snapshot.data ?? {};
                    return Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: AppText.totalEmployees,
                            value: stats['totalEmployees']?.toString() ?? '-',
                            icon: Icons.people,
                            bgColor: AppColors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            title: AppText.totalSalary,
                            value: stats['totalSalary'] ?? '-',
                            icon: Icons.attach_money,
                            bgColor: AppColors.success,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Menu Title
                Text(
                  AppText.quickActions,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Quick actions stacked vertically as three rows
                Column(
                  children: [
                    MenuGridItem(
                      title: AppText.employeeData,
                      icon: Icons.people_outline,
                      iconBgColor: AppColors.blue,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => EmployeePage(user: widget.user),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuGridItem(
                      title: AppText.payroll,
                      icon: Icons.attach_money,
                      iconBgColor: AppColors.success,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => PayrollPage(user: widget.user),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuGridItem(
                      title: AppText.attendance,
                      icon: Icons.check_circle_outline,
                      iconBgColor: AppColors.orange,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AttendancePage(user: widget.user),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      user: widget.user,
      currentIndex: 0,
      appBar: null,
      body: _buildHomePage(),
    );
  }
}
