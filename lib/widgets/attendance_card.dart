import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel attendance;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AttendanceCard({
    Key? key,
    required this.attendance,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (attendance.status) {
      case 'hadir':
        return Colors.green.shade400;
      case 'tidak_hadir':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (attendance.status) {
      case 'hadir':
        return Colors.green.shade50;
      case 'tidak_hadir':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    int? computeMinutesFromTimes() {
      final entry = attendance.entryTime;
      final exit = attendance.exitTime;
      if (entry == null || exit == null) return null;
      final entryMinutes = entry.hour * 60 + entry.minute;
      final exitMinutes = exit.hour * 60 + exit.minute;
      if (exitMinutes <= entryMinutes) return null;
      return exitMinutes - entryMinutes;
    }

    String formatHoursDisplay() {
      final minutes = computeMinutesFromTimes();
      if (minutes != null) {
        final h = minutes ~/ 60;
        final m = minutes % 60;
        if (m == 0) return '$h jam';
        return '$h jam $m menit';
      }

      // fallback to stored hoursWorked (decimal hours)
      final hw = attendance.hoursWorked;
      if (hw <= 0) return '-';
      final whole = hw.truncate();
      final frac = ((hw - whole) * 60).round();
      if (frac == 0) return '$whole jam';
      return '$whole jam $frac menit';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Header with date and status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari ke-${attendance.day}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${attendance.day}/${attendance.month}/${attendance.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Status badge
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor()),
                    ),
                    child: Text(
                      attendance.getStatusDisplay(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(height: 1, color: Colors.grey.shade200),
          // Time info (only if present or late)
          if (attendance.status != 'tidak_hadir') ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Entry time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam Masuk',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          attendance.getTimeString(attendance.entryTime),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  // Exit time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Jam Pulang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          attendance.getTimeString(attendance.exitTime),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Hours worked
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: Colors.grey.shade600, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Jam Kerja:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatHoursDisplay(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // No time info for absent
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.shade400,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tidak ada data jam kerja',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
          // Notes if exists
          if (attendance.notes != null && attendance.notes!.isNotEmpty) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.note, color: Colors.grey.shade600, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Catatan: ${attendance.notes}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Action buttons
          if (onEdit != null || onDelete != null) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (onEdit != null)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  if (onDelete != null) ...[
                    if (onEdit != null) const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Hapus'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
