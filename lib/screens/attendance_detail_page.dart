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
  Stream<List<AttendanceModel>>? _attendanceStream;
  Stream<AttendanceSummary>? _summaryStream;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _attendanceStream = AttendanceService.streamAttendanceByMonth(
      widget.employee.id,
      widget.month,
      widget.year,
    );

    // Derive summary from attendance stream
    _summaryStream = _attendanceStream!.map((records) {
      int totalDays = 0;
      int totalAbsent = 0;
      double totalHours = 0;

      for (var record in records) {
        if (record.status == 'tidak_hadir') {
          totalAbsent++;
        } else {
          // any non-absent status considered present; includes legacy 'terlambat'
          totalDays++;
          totalHours += record.hoursWorked;
        }
      }

      final standardHours = widget.employee.standardHoursPerDay * 22;
      final attendancePercentage = records.isEmpty
          ? 0.0
          : (totalDays / records.length) * 100;

      return AttendanceSummary(
        totalDaysPresent: totalDays,
        totalDaysAbsent: totalAbsent,
        totalDaysLate: 0,
        totalHoursWorked: totalHours,
        standardHours: standardHours.toDouble(),
        attendancePercentage: attendancePercentage,
      );
    });
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
    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header with employee info (profile card style)
            Container(
              decoration: const BoxDecoration(
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
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF667eea),
                      child: Text(
                        widget.employee.getInitials(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.employee.fullName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.employee.position,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bulan ${_getMonthName(widget.month)} ${widget.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Stats cards (realtime via stream)
            StreamBuilder<AttendanceSummary>(
              stream: _summaryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error loading summary: ${snapshot.error}'),
                  );
                }

                final summary =
                    snapshot.data ??
                    AttendanceSummary(
                      totalDaysPresent: 0,
                      totalDaysAbsent: 0,
                      totalDaysLate: 0,
                      totalHoursWorked: 0,
                      standardHours: widget.employee.standardHoursPerDay * 22.0,
                      attendancePercentage: 0,
                    );

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // First row: Present, Absent
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  FloatingActionButton.small(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AttendanceFormPage(employee: widget.employee),
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
            StreamBuilder<List<AttendanceModel>>(
              stream: _attendanceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error loading attendance: ${snapshot.error}'),
                  );
                }

                final records = snapshot.data ?? <AttendanceModel>[];
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
                            style: TextStyle(color: Colors.grey.shade600),
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
                        .map(
                          (attendance) => AttendanceCard(
                            attendance: attendance,
                            onEdit: () => _editAttendance(attendance),
                            onDelete: () => _deleteAttendance(attendance),
                          ),
                        )
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
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
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
