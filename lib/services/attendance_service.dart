import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference get _col => _firestore.collection('attendances');

  // Get all attendance records
  static Future<List<AttendanceModel>> getAllAttendance() async {
    try {
      final snap = await _col.get();
      return snap.docs
          .map((d) => AttendanceModel.fromJson(Map<String, dynamic>.from(d.data() as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting attendance from Firestore: $e');
      return [];
    }
  }

  // Add attendance record
  static Future<bool> addAttendance(AttendanceModel attendance) async {
    try {
      await _col.doc(attendance.id).set(attendance.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error adding attendance to Firestore: $e');
      return false;
    }
  }

  // Update attendance record
  static Future<bool> updateAttendance(AttendanceModel attendance) async {
    try {
      final docRef = _col.doc(attendance.id);
      final doc = await docRef.get();
      if (!doc.exists) return false;
      await docRef.update(attendance.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating attendance in Firestore: $e');
      return false;
    }
  }

  // Delete attendance record
  static Future<bool> deleteAttendance(String id) async {
    try {
      await _col.doc(id).delete();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting attendance from Firestore: $e');
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
      final snap = await _col
          .where('employeeId', isEqualTo: employeeId)
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .orderBy('day')
          .get();

      return snap.docs
          .map((d) => AttendanceModel.fromJson(Map<String, dynamic>.from(d.data() as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error querying attendance by month from Firestore: $e');
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
      // ignore: avoid_print
      print('Error getting attendance summary from Firestore: $e');
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

  // Generate sample attendance data for testing (uses batched writes)
  static Future<void> generateSampleAttendance(String employeeId) async {
    try {
      final now = DateTime.now();
      final existing = await _col
          .where('employeeId', isEqualTo: employeeId)
          .where('month', isEqualTo: now.month)
          .where('year', isEqualTo: now.year)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) return;

      final batch = FirebaseFirestore.instance.batch();

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

        final docRef = _col.doc(attendance.id);
        batch.set(docRef, attendance.toJson());
      }

      await batch.commit();
    } catch (e) {
      // ignore: avoid_print
      print('Error generating sample attendance in Firestore: $e');
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
      // ignore: avoid_print
      print('Error getting monthly attendance stats from Firestore: $e');
      return {};
    }
  }
}
