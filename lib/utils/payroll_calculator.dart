import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';

double calculateWorkHoursFromTimeOfDay(
  TimeOfDay? checkIn,
  TimeOfDay? checkOut,
) {
  if (checkIn == null || checkOut == null) return 0;

  final inMinutes = checkIn.hour * 60 + checkIn.minute;
  var outMinutes = checkOut.hour * 60 + checkOut.minute;

  // handle crossing midnight
  if (outMinutes < inMinutes) {
    outMinutes += 24 * 60;
  }

  return (outMinutes - inMinutes) / 60.0;
}

double calculateWorkHoursFromString(String? checkIn, String? checkOut) {
  if (checkIn == null || checkOut == null) return 0;
  try {
    final inParts = checkIn.split(':');
    final outParts = checkOut.split(':');
    final inTime = TimeOfDay(
      hour: int.parse(inParts[0]),
      minute: int.parse(inParts[1]),
    );
    final outTime = TimeOfDay(
      hour: int.parse(outParts[0]),
      minute: int.parse(outParts[1]),
    );
    return calculateWorkHoursFromTimeOfDay(inTime, outTime);
  } catch (_) {
    return 0;
  }
}

Map<String, dynamic> calculateMonthlySalary(
  EmployeeModel employee,
  List<AttendanceModel> records,
) {
  final now = DateTime.now();
  final monthRecords = records.where((rec) {
    return rec.month == now.month && rec.year == now.year;
  }).toList();

  double totalHours = 0;
  int daysPresent = 0;

  for (var rec in monthRecords) {
    if (rec.isPresent) {
      daysPresent++;
      double hours = 0;
      if (rec.hoursWorked > 0) {
        hours = rec.hoursWorked;
      } else {
        hours = calculateWorkHoursFromTimeOfDay(rec.entryTime, rec.exitTime);
      }
      totalHours += hours;
    }
  }

  final hourlyRate = employee.hourlyRate.toDouble();
  final hourlyPay = totalHours * hourlyRate;
  final transportAllowance = employee.transportAllowance.toDouble();
  final mealAllowance = employee.mealAllowance.toDouble();
  final totalSalary = hourlyPay + transportAllowance + mealAllowance;

  return {
    'hourlyPay': hourlyPay,
    'totalHours': totalHours,
    'daysPresent': daysPresent,
    'transportAllowance': transportAllowance,
    'mealAllowance': mealAllowance,
    'totalSalary': totalSalary,
    'hourlyRate': hourlyRate,
    'standardMonthlyHours': 22 * employee.standardHoursPerDay,
  };
}
