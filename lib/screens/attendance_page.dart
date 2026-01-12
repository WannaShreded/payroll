import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../services/employee_service.dart';
import '../services/attendance_service.dart';
import 'attendance_detail_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<EmployeeModel> employees = [];
  Map<String, AttendanceSummary> attendanceStats = {};
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    try {
      // Get employees
      employees = await EmployeeService.getAllEmployees();

      // Generate sample data if not exists
      for (var emp in employees) {
        await AttendanceService.generateSampleAttendance(emp.id);
      }

      // Get attendance stats
      await _loadAttendanceStats();
    } catch (e) {
      print('Error initializing: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAttendanceStats() async {
    try {
      final employeeIds = employees.map((e) => e.id).toList();
      final stats = await AttendanceService.getMonthlyAttendanceStats(
        employeeIds,
        selectedMonth,
        selectedYear,
        8, // standard hours per day
      );

      setState(() {
        attendanceStats = stats;
      });
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  int get totalPresent => attendanceStats.values
      .fold<int>(0, (sum, stat) => sum + stat.totalDaysPresent);

  int get totalAbsent => attendanceStats.values
      .fold<int>(0, (sum, stat) => sum + stat.totalDaysAbsent);

  void _onMonthChanged(int month, int year) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
    });
    _loadAttendanceStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header with gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rekap Absensi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bulan ${_getMonthName(selectedMonth)} $selectedYear',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Month selector
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () => _showMonthPicker(),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Color(0xFF667eea), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${_getMonthName(selectedMonth)} $selectedYear',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF667eea),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.shade200,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: InkWell(
                              onTap: _initializeData,
                              child: const Icon(Icons.refresh,
                                  color: Color(0xFF667eea), size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Quick stats
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Total present card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.shade200,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Hadir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$totalPresent hari',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Total absent card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.shade200,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Tidak Hadir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$totalAbsent hari',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Employee list with attendance
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...employees.map((emp) {
                          final stat = attendanceStats[emp.id];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AttendanceDetailPage(
                                    employee: emp,
                                    month: selectedMonth,
                                    year: selectedYear,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Employee name and position
                                  Text(
                                    emp.fullName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    emp.position,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Stats row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStatItem(
                                        'Hadir',
                                        '${stat?.totalDaysPresent ?? 0}',
                                        Colors.green,
                                      ),
                                      _buildStatItem(
                                        'Terlambat',
                                        '${stat?.totalDaysLate ?? 0}',
                                        Colors.orange,
                                      ),
                                      _buildStatItem(
                                        'Tidak Hadir',
                                        '${stat?.totalDaysAbsent ?? 0}',
                                        Colors.red,
                                      ),
                                      _buildStatItem(
                                        'Persentase',
                                        '${(stat?.attendancePercentage ?? 0).toStringAsFixed(0)}%',
                                        Colors.blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
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
    );
  }

  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bulan dan Tahun'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            children: [
              DropdownButton<int>(
                isExpanded: true,
                value: selectedMonth,
                items: List.generate(12, (i) => i + 1)
                    .map((month) => DropdownMenuItem(
                          value: month,
                          child: Text(_getMonthName(month)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedMonth = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButton<int>(
                isExpanded: true,
                value: selectedYear,
                items: List.generate(5, (i) => DateTime.now().year - 2 + i)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedYear = value);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _onMonthChanged(selectedMonth, selectedYear);
              Navigator.pop(context);
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}
