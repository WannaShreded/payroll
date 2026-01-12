import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';
import '../widgets/attendance_card.dart';
import 'attendance_form_page.dart';

class AttendanceDetailPage extends StatefulWidget {
  final EmployeeModel employee;
  final int month;
  final int year;

  const AttendanceDetailPage({
    Key? key,
    required this.employee,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  late Future<List<AttendanceModel>> _attendanceFuture;
  late Future<AttendanceSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _attendanceFuture = AttendanceService.getAttendanceByMonth(
      widget.employee.id,
      widget.month,
      widget.year,
    );
    _summaryFuture = AttendanceService.getAttendanceSummary(
      widget.employee.id,
      widget.month,
      widget.year,
      widget.employee.standardHoursPerDay,
    );
  }

  void _refreshData() {
    setState(() {
      _loadData();
    });
  }

  Future<void> _editAttendance(AttendanceModel attendance) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceFormPage(
          employee: widget.employee,
          attendance: attendance,
        ),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  Future<void> _deleteAttendance(AttendanceModel attendance) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Absensi'),
        content: Text(
          'Yakin ingin menghapus absensi ${widget.employee.fullName} tanggal ${attendance.day}/${attendance.month}/${attendance.year}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await AttendanceService.deleteAttendance(attendance.id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Absensi berhasil dihapus')),
          );
          _refreshData();
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Detail Absensi'),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with employee info
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.employee.getInitials(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name and position
                  Text(
                    widget.employee.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.employee.position,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Month and year
                  Text(
                    'Bulan ${_getMonthName(widget.month)} ${widget.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            // Stats cards
            FutureBuilder<AttendanceSummary>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                final summary = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // First row: Present, Late, Absent
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Hadir',
                              '${summary.totalDaysPresent}',
                              Colors.green,
                              Icons.check_circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Terlambat',
                              '${summary.totalDaysLate}',
                              Colors.orange,
                              Icons.schedule,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Tidak Hadir',
                              '${summary.totalDaysAbsent}',
                              Colors.red,
                              Icons.cancel,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Attendance percentage
                      _buildStatCard(
                        'Persentase Kehadiran',
                        '${summary.attendancePercentage.toStringAsFixed(1)}%',
                        Colors.blue,
                        Icons.percent,
                      ),
                      const SizedBox(height: 12),
                      // Hours worked
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jam Kerja',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jam Aktual',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${summary.totalHoursWorked.toStringAsFixed(1)} jam',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF667eea),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey.shade200,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Standar Bulanan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${summary.standardHours.toStringAsFixed(1)} jam',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF764ba2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Attendance history
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Absensi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceFormPage(
                            employee: widget.employee,
                          ),
                        ),
                      );
                      if (result == true) {
                        _refreshData();
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<AttendanceModel>>(
              future: _attendanceFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                final records = snapshot.data!;
                if (records.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada data absensi',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: records
                        .map((attendance) => AttendanceCard(
                              attendance: attendance,
                              onEdit: () => _editAttendance(attendance),
                              onDelete: () => _deleteAttendance(attendance),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
