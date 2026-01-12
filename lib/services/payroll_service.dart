import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/payroll_model.dart';
import '../models/employee_model.dart';
import 'attendance_service.dart';

class PayrollService {
  static const String _payrollKey = 'payroll_records';

  // Get all payroll records
  static Future<List<PayrollModel>> getAllPayroll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payrollJson = prefs.getStringList(_payrollKey) ?? [];
      return payrollJson
          .map((json) => PayrollModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error getting payroll: $e');
      return [];
    }
  }

  // Calculate and create payroll for employee
  static Future<PayrollModel> calculatePayroll(
    EmployeeModel employee,
    int month,
    int year,
  ) async {
    try {
      // Get attendance summary
      final attendance = await AttendanceService.getAttendanceSummary(
        employee.id,
        month,
        year,
        employee.standardHoursPerDay,
      );

      // Calculate salary
      final baseSalary =
          (employee.hourlyRate * attendance.totalHoursWorked).toInt();
      final totalNetSalary =
          baseSalary + employee.transportAllowance + employee.mealAllowance;

      final payroll = PayrollModel(
        id: '${employee.id}_${month}_${year}',
        employeeId: employee.id,
        month: month,
        year: year,
        baseSalary: baseSalary,
        transportAllowance: employee.transportAllowance,
        mealAllowance: employee.mealAllowance,
        totalNetSalary: totalNetSalary,
        totalDaysPresent: attendance.totalDaysPresent,
        totalHoursWorked: attendance.totalHoursWorked,
        hourlyRate: employee.hourlyRate,
        createdAt: DateTime.now(),
      );

      return payroll;
    } catch (e) {
      print('Error calculating payroll: $e');
      rethrow;
    }
  }

  // Save payroll record
  static Future<bool> savePayroll(PayrollModel payroll) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final records = await getAllPayroll();

      // Remove existing payroll for same employee/month/year
      records.removeWhere((p) {
        return p.employeeId == payroll.employeeId &&
            p.month == payroll.month &&
            p.year == payroll.year;
      });

      records.add(payroll);

      final payrollJson = records
          .map((p) => jsonEncode(p.toJson()))
          .toList();

      await prefs.setStringList(_payrollKey, payrollJson);
      return true;
    } catch (e) {
      print('Error saving payroll: $e');
      return false;
    }
  }

  // Get payroll for specific month
  static Future<PayrollModel?> getPayrollByMonth(
    String employeeId,
    int month,
    int year,
  ) async {
    try {
      final records = await getAllPayroll();
      final payroll = records.firstWhere(
        (p) =>
            p.employeeId == employeeId &&
            p.month == month &&
            p.year == year,
        orElse: () => PayrollModel(
          id: '',
          employeeId: employeeId,
          month: month,
          year: year,
          baseSalary: 0,
          transportAllowance: 0,
          mealAllowance: 0,
          totalNetSalary: 0,
          totalDaysPresent: 0,
          totalHoursWorked: 0,
          hourlyRate: 0,
          createdAt: DateTime.now(),
        ),
      );
      return payroll.id.isNotEmpty ? payroll : null;
    } catch (e) {
      print('Error getting payroll: $e');
      return null;
    }
  }

  // Get payroll history for employee
  static Future<List<PayrollModel>> getPayrollHistory(String employeeId) async {
    try {
      final records = await getAllPayroll();
      return records.where((p) => p.employeeId == employeeId).toList()
        ..sort((a, b) {
          if (a.year != b.year) return b.year.compareTo(a.year);
          return b.month.compareTo(a.month);
        });
    } catch (e) {
      print('Error getting payroll history: $e');
      return [];
    }
  }
}
