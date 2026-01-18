import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../services/employee_service.dart';
import '../services/attendance_service.dart';
import 'attendance_detail_page.dart';
import '../widgets/app_shell.dart';

class AttendancePage extends StatefulWidget {
  final UserModel user;

  const AttendancePage({Key? key, required this.user}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<EmployeeModel> employees = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool isLoading = true;
  Stream<Map<String, AttendanceSummary>>? _statsStream;

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
      _statsStream = AttendanceService.streamMonthlyAttendanceStats(
        employees.map((e) => e.id).toList(),
        selectedMonth,
        selectedYear,
        8, // standard hours per day
      );
    } catch (e) {
      print('Error initializing: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // totals will be computed from the realtime stats stream in the UI

  void _onMonthChanged(int month, int year) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
    });
    // recreate stream for new month/year
    _statsStream = AttendanceService.streamMonthlyAttendanceStats(
      employees.map((e) => e.id).toList(),
      selectedMonth,
      selectedYear,
      8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      user: widget.user,
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        title: const Text('Rekap Absensi'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header with card-style and month selector inside
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rekap Absensi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Bulan ${_getMonthName(selectedMonth)} $selectedYear',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => _showMonthPicker(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFF667eea),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_getMonthName(selectedMonth)} $selectedYear',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF667eea),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _initializeData,
                                child: const Icon(
                                  Icons.refresh,
                                  color: Color(0xFF667eea),
                                  size: 20,
                                ),
                              ),
                            ],
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
                        // Total present card (realtime)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
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
                                StreamBuilder<Map<String, AttendanceSummary>>(
                                  stream: _statsStream,
                                  builder: (context, snap) {
                                    final map = snap.data ?? {};
                                    final totalPresent = map.values.fold<int>(
                                      0,
                                      (s, v) => s + v.totalDaysPresent,
                                    );
                                    return Text(
                                      '$totalPresent hari',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Total absent card (realtime)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
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
                                StreamBuilder<Map<String, AttendanceSummary>>(
                                  stream: _statsStream,
                                  builder: (context, snap) {
                                    final map = snap.data ?? {};
                                    final totalAbsent = map.values.fold<int>(
                                      0,
                                      (s, v) => s + v.totalDaysAbsent,
                                    );
                                    return Text(
                                      '$totalAbsent hari',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    );
                                  },
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppShell(
                                    user: widget.user,
                                    currentIndex: 0,
                                    appBar: AppBar(
                                      title: const Text('Detail Absensi'),
                                      backgroundColor: const Color(0xFF667eea),
                                    ),
                                    body: AttendanceDetailPage(
                                      employee: emp,
                                      month: selectedMonth,
                                      year: selectedYear,
                                    ),
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
                                border: Border.all(color: Colors.grey.shade200),
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
                                      StreamBuilder<
                                        Map<String, AttendanceSummary>
                                      >(
                                        stream: _statsStream,
                                        builder: (context, snap) {
                                          final m = snap.data ?? {};
                                          final s = m[emp.id];
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _buildStatItem(
                                                'Hadir',
                                                '${s?.totalDaysPresent ?? 0}',
                                                Colors.green,
                                              ),
                                              const SizedBox(width: 8),
                                              _buildStatItem(
                                                'Tidak Hadir',
                                                '${s?.totalDaysAbsent ?? 0}',
                                                Colors.red,
                                              ),
                                              const SizedBox(width: 8),
                                              _buildStatItem(
                                                'Persentase',
                                                '${(s?.attendancePercentage ?? 0).toStringAsFixed(0)}%',
                                                Colors.blue,
                                              ),
                                            ],
                                          );
                                        },
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
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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
                    .map(
                      (month) => DropdownMenuItem(
                        value: month,
                        child: Text(_getMonthName(month)),
                      ),
                    )
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
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
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
