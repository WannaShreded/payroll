import 'dart:async';
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
          .map(
            (d) => AttendanceModel.fromJson(
              Map<String, dynamic>.from(d.data() as Map),
            ),
          )
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
      // To avoid requiring a composite index, query by employeeId only
      // and filter/sort client-side by month/year/day.
      final snap = await _col.where('employeeId', isEqualTo: employeeId).get();

      final list = snap.docs
          .map(
            (d) => AttendanceModel.fromJson(
              Map<String, dynamic>.from(d.data() as Map),
            ),
          )
          .where((a) => a.month == month && a.year == year)
          .toList();

      list.sort((a, b) => a.day.compareTo(b.day));
      return list;
    } catch (e) {
      // ignore: avoid_print
      print('Error querying attendance by month from Firestore: $e');
      return [];
    }
  }

  // Stream attendance for a specific employee/month/year for realtime updates
  static Stream<List<AttendanceModel>> streamAttendanceByMonth(
    String employeeId,
    int month,
    int year,
  ) {
    // Use a StreamController to intercept snapshot errors (e.g. missing composite index)
    final controller = StreamController<List<AttendanceModel>>.broadcast();
    late StreamSubscription<QuerySnapshot> sub;

    void start() {
      try {
        // Query by employeeId only to avoid composite index requirement.
        final query = _col.where('employeeId', isEqualTo: employeeId);

        sub = query.snapshots().listen(
          (snap) {
            final List<AttendanceModel> list = [];
            for (var d in snap.docs) {
              try {
                final data = Map<String, dynamic>.from(d.data() as Map);
                final att = AttendanceModel.fromJson(data);
                if (att.month == month && att.year == year) list.add(att);
              } catch (e) {
                // ignore: avoid_print
                print('Error parsing attendance doc ${d.id}: $e');
                // skip problematic document
              }
            }
            list.sort((a, b) => a.day.compareTo(b.day));
            controller.add(list);
          },
          onError: (e) {
            // ignore: avoid_print
            print('Attendance snapshots error: $e');
            // emit empty list so UI can render instead of staying stuck
            controller.add(<AttendanceModel>[]);
          },
        );
      } catch (e) {
        // ignore: avoid_print
        print('Error creating attendance stream: $e');
        controller.add(<AttendanceModel>[]);
      }
    }

    start();

    controller.onCancel = () async {
      try {
        await sub.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
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
      double totalHours = 0;

      for (var record in records) {
        if (record.status == 'tidak_hadir') {
          totalAbsent++;
        } else {
          // treat any non-absent (including legacy 'terlambat') as present
          totalDays++;
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
        totalDaysLate: 0,
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
      // Check existence by querying by employeeId and inspecting month/year client-side
      final existingSnap = await _col
          .where('employeeId', isEqualTo: employeeId)
          .limit(50)
          .get();
      final alreadyExists = existingSnap.docs.any((d) {
        try {
          final data = Map<String, dynamic>.from(d.data() as Map);
          final att = AttendanceModel.fromJson(data);
          return att.month == now.month && att.year == now.year;
        } catch (_) {
          return false;
        }
      });

      if (alreadyExists) return;

      final batch = FirebaseFirestore.instance.batch();

      for (int day = 1; day <= 22; day++) {
        final isAbsent = day % 10 == 0;
        final lateMinute = day % 7 == 0
            ? 30
            : 0; // mark some days as late but treat as hadir
        final status = isAbsent ? 'tidak_hadir' : 'hadir';
        final entryMinute = isAbsent ? 0 : lateMinute;

        const exitHour = 17;
        const exitMinute = 0;
        int minutesWorked = 0;
        if (!isAbsent) {
          final entryTotal = 8 * 60 + entryMinute;
          const exitTotal = exitHour * 60 + exitMinute;
          minutesWorked = (exitTotal - entryTotal).clamp(0, 24 * 60);
        }

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
              ? const TimeOfDay(hour: exitHour, minute: exitMinute)
              : null,
          hoursWorked: status != 'tidak_hadir' ? (minutesWorked / 60.0) : 0,
          isPresent: status != 'tidak_hadir',
          notes: (!isAbsent && lateMinute > 0)
              ? 'Terlambat $lateMinute menit'
              : null,
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

  // Stream monthly attendance stats for a set of employees
  static Stream<Map<String, AttendanceSummary>> streamMonthlyAttendanceStats(
    List<String> employeeIds,
    int month,
    int year,
    int standardHoursPerDay,
  ) {
    final controller =
        StreamController<Map<String, AttendanceSummary>>.broadcast();
    late StreamSubscription<QuerySnapshot> sub;

    void start() {
      try {
        final query = _col
            .where('month', isEqualTo: month)
            .where('year', isEqualTo: year);

        sub = query.snapshots().listen(
          (snap) {
            final grouped = <String, List<AttendanceModel>>{};
            for (var doc in snap.docs) {
              try {
                final data = Map<String, dynamic>.from(doc.data() as Map);
                final att = AttendanceModel.fromJson(data);
                if (!employeeIds.contains(att.employeeId)) continue;
                grouped.putIfAbsent(att.employeeId, () => []).add(att);
              } catch (e) {
                // ignore: avoid_print
                print('Error parsing attendance doc ${doc.id}: $e');
                // skip problematic document
              }
            }

            final stats = <String, AttendanceSummary>{};
            for (var empId in employeeIds) {
              final records = grouped[empId] ?? [];
              int totalDays = 0;
              int totalAbsent = 0;
              double totalHours = 0;

              for (var record in records) {
                if (record.status == 'tidak_hadir') {
                  totalAbsent++;
                } else {
                  totalDays++;
                  totalHours += record.hoursWorked;
                }
              }

              final standardHours = standardHoursPerDay * 22;
              final attendancePercentage = records.isEmpty
                  ? 0.0
                  : (totalDays / records.length) * 100;

              stats[empId] = AttendanceSummary(
                totalDaysPresent: totalDays,
                totalDaysAbsent: totalAbsent,
                totalDaysLate: 0,
                totalHoursWorked: totalHours,
                standardHours: standardHours.toDouble(),
                attendancePercentage: attendancePercentage,
              );
            }

            controller.add(stats);
          },
          onError: (e) {
            // ignore: avoid_print
            print('Monthly attendance snapshots error: $e');
            // emit empty map so UI can render fallback state
            controller.add(<String, AttendanceSummary>{});
          },
        );
      } catch (e) {
        // ignore: avoid_print
        print('Error creating monthly stats stream: $e');
        controller.add(<String, AttendanceSummary>{});
      }
    }

    start();

    controller.onCancel = () async {
      try {
        await sub.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }
}
