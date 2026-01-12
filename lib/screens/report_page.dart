import 'package:flutter/material.dart';
import '../services/employee_service.dart';
import '../services/payroll_service.dart';
import '../services/attendance_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isLoading = true;
  int _totalEmployees = 0;
  double _totalSalary = 0;
  double _averageSalary = 0;
  double _attendancePercentage = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      setState(() => _isLoading = true);

      // Get total employees
      final employees = await EmployeeService.getAllEmployees();
      _totalEmployees = employees.length;

      // Get payroll data for current month
      final now = DateTime.now();
      final payrollRecords = await PayrollService.getAllPayroll();
      final currentMonthPayroll = payrollRecords.where((p) =>
          p.month == now.month && p.year == now.year);

      _totalSalary = currentMonthPayroll.fold<double>(
          0, (sum, payroll) => sum + payroll.totalNetSalary);

      _averageSalary = _totalEmployees > 0
          ? _totalSalary / _totalEmployees
          : 0;

      // Calculate attendance percentage
      if (_totalEmployees > 0) {
        int totalPresent = 0;
        int totalDays = 0;

        for (var emp in employees) {
          final attendance = await AttendanceService.getAttendanceSummary(
            emp.id,
            now.month,
            now.year,
            emp.standardHoursPerDay,
          );
          totalPresent += attendance.totalDaysPresent;
          totalDays += 22; // 22 working days per month
        }

        _attendancePercentage =
            totalDays > 0 ? (totalPresent / totalDays) * 100 : 0;
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading statistics: $e');
      setState(() => _isLoading = false);
    }
  }

  String _formatCurrency(double amount) {
    final formatter = amount.toStringAsFixed(0);
    final parts = formatter.split('');
    final result = <String>[];

    for (int i = parts.length - 1; i >= 0; i--) {
      if (result.length > 0 && result.length % 3 == 0) {
        result.insert(0, '.');
      }
      result.insert(0, parts[i]);
    }

    return 'Rp ${result.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistik Bulan Ini',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ringkasan data karyawan, gaji, dan absensi',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Statistics cards (4 columns)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Karyawan',
                                '$_totalEmployees',
                                Colors.blue,
                                Icons.people,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Total Gaji',
                                _formatCurrency(_totalSalary),
                                Colors.green,
                                Icons.attach_money,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Rata-rata Gaji',
                                _formatCurrency(_averageSalary),
                                Colors.orange,
                                Icons.trending_up,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Tingkat Kehadiran',
                                '${_attendancePercentage.toStringAsFixed(1)}%',
                                Colors.purple,
                                Icons.check_circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu Laporan
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Menu Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            _buildReportMenuItem(
                              'Laporan Karyawan',
                              Icons.person_search,
                              Colors.blue,
                              () => _showComingSoon('Laporan Karyawan'),
                            ),
                            _buildReportMenuItem(
                              'Laporan Gaji',
                              Icons.receipt,
                              Colors.green,
                              () => _showComingSoon('Laporan Gaji'),
                            ),
                            _buildReportMenuItem(
                              'Laporan Absensi',
                              Icons.calendar_today,
                              Colors.orange,
                              () => _showComingSoon('Laporan Absensi'),
                            ),
                            _buildReportMenuItem(
                              'Laporan Kinerja',
                              Icons.assessment,
                              Colors.purple,
                              () => _showComingSoon('Laporan Kinerja'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _showComingSoon('Export ke Excel'),
                            icon: const Icon(Icons.download),
                            label: const Text('Export Excel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _showComingSoon('Cetak Laporan'),
                            icon: const Icon(Icons.print),
                            label: const Text('Cetak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667eea),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportMenuItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature - Segera hadir')),
    );
  }
}
