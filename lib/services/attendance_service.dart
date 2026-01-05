import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/attendance_model.dart';

class AttendanceService {
  static const String _attendanceKey = 'attendance_records';

  // Get all attendance records
  static Future<List<AttendanceModel>> getAllAttendance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attendanceJson = prefs.getStringList(_attendanceKey) ?? [];
      return attendanceJson
          .map((json) => AttendanceModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error getting attendance: $e');
      return [];
    }
  }

  // Add attendance record
  static Future<bool> addAttendance(AttendanceModel attendance) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getAllAttendance();
      records.add(attendance);

      final attendanceJson = records
          .map((att) => jsonEncode(att.toJson()))
          .toList();

      await prefs.setStringList(_attendanceKey, attendanceJson);
      return true;
    } catch (e) {
      print('Error adding attendance: $e');
      return false;
    }
  }

  // Get attendance for specific month
  static Future<List<AttendanceModel>> getAttendanceByMonth(
    String employeeId,
    int month,
    int year,
  ) async {
    try {
      final allRecords = await getAllAttendance();
      return allRecords.where((att) {
        return att.employeeId == employeeId &&
            att.month == month &&
            att.year == year;
      }).toList();
    } catch (e) {
      print('Error getting attendance by month: $e');
      return [];
    }
  }

  // Get attendance summary for month
  static Future<AttendanceSummary> getAttendanceSummary(
    String employeeId,
    int month,
    int year,
  ) async {
    try {
      final records = await getAttendanceByMonth(employeeId, month, year);
      int totalDays = 0;
      double totalHours = 0;

      for (var record in records) {
        if (record.isPresent) {
          totalDays++;
          totalHours += record.hoursWorked;
        }
      }

      return AttendanceSummary(
        totalDaysPresent: totalDays,
        totalHoursWorked: totalHours,
      );
    } catch (e) {
      print('Error getting attendance summary: $e');
      return AttendanceSummary(
        totalDaysPresent: 0,
        totalHoursWorked: 0,
      );
    }
  }

  // Generate sample attendance data for testing
  static Future<void> generateSampleAttendance(String employeeId) async {
    try {
      final now = DateTime.now();
      final records = await getAllAttendance();

      // Check if sample data already exists for this month
      final existing = records.where((att) {
        return att.employeeId == employeeId &&
            att.month == now.month &&
            att.year == now.year;
      }).length;

      if (existing > 0) return;

      // Generate sample data for the month
      for (int day = 1; day <= 22; day++) {
        // Only 22 working days
        final attendance = AttendanceModel(
          id: '${employeeId}_${now.month}_${now.year}_$day',
          employeeId: employeeId,
          day: day,
          month: now.month,
          year: now.year,
          hoursWorked: 8.0, // 8 hours per day
          isPresent: true,
          notes: 'Regular working day',
        );
        await addAttendance(attendance);
      }
    } catch (e) {
      print('Error generating sample attendance: $e');
    }
  }
}
