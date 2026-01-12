import 'package:flutter/material.dart';

class AttendanceModel {
  final String id;
  final String employeeId;
  final int day; // 1-31
  final int month; // 1-12
  final int year;
  final String status; // 'hadir', 'terlambat', 'tidak_hadir'
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
    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null) return null;
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      return null;
    }

    return AttendanceModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      status: json['status'] ?? 'tidak_hadir',
      entryTime: parseTime(json['entryTime']),
      exitTime: parseTime(json['exitTime']),
      hoursWorked: (json['hoursWorked'] ?? 0).toDouble(),
      isPresent: json['isPresent'] ?? false,
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
        return 'Hadir';
      case 'terlambat':
        return 'Terlambat';
      case 'tidak_hadir':
        return 'Tidak Hadir';
      default:
        return 'Tidak Diketahui';
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

