import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class AttendanceModel {
  final String id;
  final String employeeId;
  final int day; // 1-31
  final int month; // 1-12
  final int year;
  final String status; // 'hadir', 'tidak_hadir' (legacy 'terlambat' treated as 'hadir')
  final TimeOfDay? entryTime; // Jam masuk (HH:MM)
  final TimeOfDay? exitTime; // Jam pulang (HH:MM)
  final double hoursWorked; // actual hours worked
  final bool isPresent;
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.day,
    required this.month,
    required this.year,
    required this.status,
    this.entryTime,
    this.exitTime,
    this.hoursWorked = 0,
    required this.isPresent,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'day': day,
      'month': month,
      'year': year,
      'status': status,
      'entryTime': entryTime != null ? '${entryTime!.hour}:${entryTime!.minute}' : null,
      'exitTime': exitTime != null ? '${exitTime!.hour}:${exitTime!.minute}' : null,
      'hoursWorked': hoursWorked,
      'isPresent': isPresent,
      'notes': notes,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(dynamic timeVal) {
      if (timeVal == null) return null;
      try {
        // String like '08:30' or '8:30'
        if (timeVal is String) {
          final parts = timeVal.split(':');
          if (parts.length >= 2) {
            final h = int.tryParse(parts[0].trim());
            final m = int.tryParse(parts[1].trim());
            if (h != null && m != null) return TimeOfDay(hour: h, minute: m);
          }
        }

        // Firestore Timestamp
        if (timeVal is Timestamp) {
          final dt = timeVal.toDate();
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        }

        // Numeric epoch milliseconds
        if (timeVal is int) {
          final dt = DateTime.fromMillisecondsSinceEpoch(timeVal);
          return TimeOfDay(hour: dt.hour, minute: dt.minute);
        }

        // List like [hour, minute]
        if (timeVal is List && timeVal.length >= 2) {
          final h = int.tryParse(timeVal[0].toString());
          final m = int.tryParse(timeVal[1].toString());
          if (h != null && m != null) return TimeOfDay(hour: h, minute: m);
        }

        // Map like {'hour':8,'minute':30} or {'h':8,'m':30}
        if (timeVal is Map) {
          final dynamic hh = timeVal['hour'] ?? timeVal['h'] ?? timeVal['hours'] ?? timeVal['0'];
          final dynamic mm = timeVal['minute'] ?? timeVal['m'] ?? timeVal['minutes'] ?? timeVal['1'];
          final h = int.tryParse(hh?.toString() ?? '');
          final m = int.tryParse(mm?.toString() ?? '');
          if (h != null && m != null) return TimeOfDay(hour: h, minute: m);
        }
      } catch (_) {
        // ignore and return null
      }
      return null;
    }

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    return AttendanceModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      day: (json['day'] is int) ? json['day'] : int.tryParse(json['day']?.toString() ?? '') ?? 0,
      month: (json['month'] is int) ? json['month'] : int.tryParse(json['month']?.toString() ?? '') ?? 0,
      year: (json['year'] is int) ? json['year'] : int.tryParse(json['year']?.toString() ?? '') ?? 0,
      status: json['status'] ?? 'tidak_hadir',
      entryTime: parseTime(json['entryTime']),
      exitTime: parseTime(json['exitTime']),
      hoursWorked: parseDouble(json['hoursWorked']),
      isPresent: parseBool(json['isPresent']),
      notes: json['notes'],
    );
  }

  AttendanceModel copyWith({
    String? id,
    String? employeeId,
    int? day,
    int? month,
    int? year,
    String? status,
    TimeOfDay? entryTime,
    TimeOfDay? exitTime,
    double? hoursWorked,
    bool? isPresent,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      status: status ?? this.status,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      isPresent: isPresent ?? this.isPresent,
      notes: notes ?? this.notes,
    );
  }

  String getStatusDisplay() {
    switch (status) {
      case 'hadir':
      case 'terlambat':
        // treat legacy 'terlambat' as hadir for display purposes
        return 'Hadir';
      case 'tidak_hadir':
        return 'Tidak Hadir';
      default:
        return 'Hadir';
    }
  }

  String getTimeString(TimeOfDay? time) {
    if (time == null) return '-';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class AttendanceSummary {
  final int totalDaysPresent;
  final int totalDaysAbsent;
  final int totalDaysLate;
  final double totalHoursWorked;
  final double standardHours;
  final double attendancePercentage;

  AttendanceSummary({
    required this.totalDaysPresent,
    required this.totalDaysAbsent,
    required this.totalDaysLate,
    required this.totalHoursWorked,
    required this.standardHours,
    required this.attendancePercentage,
  });
}

