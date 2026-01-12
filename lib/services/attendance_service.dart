import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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

  // Update attendance record
  static Future<bool> updateAttendance(AttendanceModel attendance) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getAllAttendance();
      
      final index = records.indexWhere((a) => a.id == attendance.id);
      if (index != -1) {
        records[index] = attendance;
        
        final attendanceJson = records
            .map((att) => jsonEncode(att.toJson()))
            .toList();
        
        await prefs.setStringList(_attendanceKey, attendanceJson);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating attendance: $e');
      return false;
    }
  }

  // Delete attendance record
  static Future<bool> deleteAttendance(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getAllAttendance();
      
      records.removeWhere((a) => a.id == id);
      
      final attendanceJson = records
          .map((att) => jsonEncode(att.toJson()))
          .toList();
      
      await prefs.setStringList(_attendanceKey, attendanceJson);
      return true;
    } catch (e) {
      print('Error deleting attendance: $e');
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
      }).toList()..sort((a, b) => a.day.compareTo(b.day));
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
    int standardHoursPerDay,
  ) async {
    try {
      final records = await getAttendanceByMonth(employeeId, month, year);
      int totalDays = 0;
      int totalAbsent = 0;
      int totalLate = 0;
      double totalHours = 0;

      for (var record in records) {
        if (record.status == 'hadir') {
          totalDays++;
          totalHours += record.hoursWorked;
        } else if (record.status == 'tidak_hadir') {
          totalAbsent++;
        } else if (record.status == 'terlambat') {
          totalLate++;
          totalHours += record.hoursWorked;
        }
      }

      final standardHours = standardHoursPerDay * 22; // 22 working days
      final attendancePercentage = records.isEmpty 
          ? 0.0 
          : (totalDays / records.length) * 100;

      return AttendanceSummary(
        totalDaysPresent: totalDays,
        totalDaysAbsent: totalAbsent,
        totalDaysLate: totalLate,
        totalHoursWorked: totalHours,
        standardHours: standardHours.toDouble(),
        attendancePercentage: attendancePercentage,
      );
    } catch (e) {
      print('Error getting attendance summary: $e');
      return AttendanceSummary(
        totalDaysPresent: 0,
        totalDaysAbsent: 0,
        totalDaysLate: 0,
        totalHoursWorked: 0,
        standardHours: 0,
        attendancePercentage: 0,
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

      // Generate sample data for the month (22 working days)
      for (int day = 1; day <= 22; day++) {
        final status = day % 10 == 0 ? 'tidak_hadir' : (day % 7 == 0 ? 'terlambat' : 'hadir');
        
        final entryMinute = status == 'terlambat' ? 30 : 0;
        final attendance = AttendanceModel(
          id: '${employeeId}_${now.month}_${now.year}_$day',
          employeeId: employeeId,
          day: day,
          month: now.month,
          year: now.year,
          status: status,
          entryTime: status != 'tidak_hadir' 
              ? TimeOfDay(hour: 8, minute: entryMinute)
              : null,
          exitTime: status != 'tidak_hadir' 
              ? const TimeOfDay(hour: 17, minute: 0)
              : null,
          hoursWorked: status != 'tidak_hadir' ? 8.5 : 0,
          isPresent: status != 'tidak_hadir',
          notes: status == 'terlambat' ? 'Terlambat 30 menit' : null,
        );
        await addAttendance(attendance);
      }
    } catch (e) {
      print('Error generating sample attendance: $e');
    }
  }

  // Get all employees' attendance for current month
  static Future<Map<String, AttendanceSummary>> getMonthlyAttendanceStats(
    List<String> employeeIds,
    int month,
    int year,
    int standardHoursPerDay,
  ) async {
    try {
      final stats = <String, AttendanceSummary>{};
      for (var empId in employeeIds) {
        stats[empId] = await getAttendanceSummary(
          empId,
          month,
          year,
          standardHoursPerDay,
        );
      }
      return stats;
    } catch (e) {
      print('Error getting monthly attendance stats: $e');
      return {};
    }
  }
}
