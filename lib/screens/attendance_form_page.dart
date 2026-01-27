import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceFormPage extends StatefulWidget {
  final EmployeeModel employee;
  final AttendanceModel? attendance;

  const AttendanceFormPage({Key? key, required this.employee, this.attendance})
    : super(key: key);

  @override
  State<AttendanceFormPage> createState() => _AttendanceFormPageState();
}

class _AttendanceFormPageState extends State<AttendanceFormPage> {
  late DateTime selectedDate;
  late String selectedStatus;
  late TimeOfDay? entryTime;
  late TimeOfDay? exitTime;
  late String notes;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    if (widget.attendance != null) {
      // Edit mode
      selectedDate = DateTime(
        widget.attendance!.year,
        widget.attendance!.month,
        widget.attendance!.day,
      );
      selectedStatus = widget.attendance!.status;
      entryTime = widget.attendance!.entryTime;
      exitTime = widget.attendance!.exitTime;
      notes = widget.attendance!.notes ?? '';
      _notesController.text = notes;
    } else {
      // Add mode
      selectedDate = now;
      selectedStatus = 'hadir';
      entryTime = const TimeOfDay(hour: 8, minute: 0);
      exitTime = const TimeOfDay(hour: 17, minute: 0);
      notes = '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF667eea)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(bool isEntry) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isEntry
          ? (entryTime ?? const TimeOfDay(hour: 8, minute: 0))
          : (exitTime ?? const TimeOfDay(hour: 17, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF667eea)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isEntry) {
          entryTime = picked;
        } else {
          exitTime = picked;
        }
      });
    }
  }

  bool _validateForm() {
    if (selectedStatus != 'tidak_hadir') {
      if (entryTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Jam masuk harus diisi')));
        return false;
      }

      if (exitTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Jam pulang harus diisi')));
        return false;
      }

      // Check if exit time is after entry time
      final entryMinutes = entryTime!.hour * 60 + entryTime!.minute;
      final exitMinutes = exitTime!.hour * 60 + exitTime!.minute;

      if (exitMinutes <= entryMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jam pulang harus lebih besar dari jam masuk'),
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _saveAttendance() async {
    if (!_validateForm()) return;

    final hoursWorked = selectedStatus == 'tidak_hadir'
        ? 0.0
        : _calculateHoursWorked();

    final attendance = AttendanceModel(
      id:
          widget.attendance?.id ??
          '${widget.employee.id}_${selectedDate.month}_${selectedDate.year}_${selectedDate.day}',
      employeeId: widget.employee.id,
      day: selectedDate.day,
      month: selectedDate.month,
      year: selectedDate.year,
      status: selectedStatus,
      entryTime: selectedStatus != 'tidak_hadir' ? entryTime : null,
      exitTime: selectedStatus != 'tidak_hadir' ? exitTime : null,
      hoursWorked: hoursWorked,
      isPresent: selectedStatus != 'tidak_hadir',
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    bool success;
    if (widget.attendance != null) {
      success = await AttendanceService.updateAttendance(attendance);
    } else {
      success = await AttendanceService.addAttendance(attendance);
    }

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.attendance != null
                  ? 'Absensi berhasil diperbarui'
                  : 'Absensi berhasil ditambahkan',
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan absensi')),
        );
      }
    }
  }

  double _calculateHoursWorked() {
    if (entryTime == null || exitTime == null) return 0;

    final entryMinutes = entryTime!.hour * 60 + entryTime!.minute;
    final exitMinutes = exitTime!.hour * 60 + exitTime!.minute;

    final differenceMinutes = exitMinutes - entryMinutes;
    return differenceMinutes / 60.0;
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
    final isEditMode = widget.attendance != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Absensi' : 'Tambah Absensi'),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(77),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.employee.getInitials(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.employee.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date field
                  Text(
                    'Tanggal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Status dropdown
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedStatus,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'hadir', child: Text('Hadir')),
                        DropdownMenuItem(
                          value: 'tidak_hadir',
                          child: Text('Tidak Hadir'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => selectedStatus = value ?? 'hadir');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Entry time (only if not absent)
                  if (selectedStatus != 'tidak_hadir') ...[
                    Text(
                      'Jam Masuk',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectTime(true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entryTime != null
                                  ? '${entryTime!.hour.toString().padLeft(2, '0')}:${entryTime!.minute.toString().padLeft(2, '0')}'
                                  : 'Pilih waktu',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.access_time, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Exit time
                    Text(
                      'Jam Pulang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectTime(false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exitTime != null
                                  ? '${exitTime!.hour.toString().padLeft(2, '0')}:${exitTime!.minute.toString().padLeft(2, '0')}'
                                  : 'Pilih waktu',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(Icons.access_time, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Hours display
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Jam Kerja',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${_calculateHoursWorked().toStringAsFixed(1)} jam',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Notes field
                  Text(
                    'Catatan (Opsional)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tulis catatan jika ada...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isEditMode)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final localContext = context;
                              final confirmed = await showDialog<bool>(
                                context: localContext,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Absensi'),
                                  content: const Text(
                                    'Yakin ingin menghapus absensi ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                if (!mounted) return;
                                final success =
                                    await AttendanceService.deleteAttendance(
                                      widget.attendance!.id,
                                    );
                                if (success && mounted) {
                                  ScaffoldMessenger.of(localContext).showSnackBar(
                                    const SnackBar(
                                      content: Text('Absensi berhasil dihapus'),
                                    ),
                                  );
                                  Navigator.pop(localContext, true);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      if (isEditMode) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
