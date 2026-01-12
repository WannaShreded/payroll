import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payroll_model.dart';
import '../models/employee_model.dart';
import 'attendance_service.dart';

class PayrollService {
  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference get _col => _firestore.collection('payrolls');

  // Get all payroll records
  static Future<List<PayrollModel>> getAllPayroll() async {
    try {
      final snap = await _col.get();
      return snap.docs
          .map((d) => PayrollModel.fromJson(Map<String, dynamic>.from(d.data() as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting payroll from Firestore: $e');
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
      // ignore: avoid_print
      print('Error calculating payroll: $e');
      rethrow;
    }
  }

  // Save payroll record
  static Future<bool> savePayroll(PayrollModel payroll) async {
    try {
      final docRef = _col.doc(payroll.id);

      // Upsert payroll for same employee/month/year
      await docRef.set(payroll.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error saving payroll to Firestore: $e');
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
      final snap = await _col
          .where('employeeId', isEqualTo: employeeId)
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;
      return PayrollModel.fromJson(Map<String, dynamic>.from(snap.docs.first.data() as Map));
    } catch (e) {
      // ignore: avoid_print
      print('Error getting payroll by month from Firestore: $e');
      return null;
    }
  }

  // Get payroll history for employee
  static Future<List<PayrollModel>> getPayrollHistory(String employeeId) async {
    try {
      final snap = await _col
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('year', descending: true)
          .orderBy('month', descending: true)
          .get();

      return snap.docs
          .map((d) => PayrollModel.fromJson(Map<String, dynamic>.from(d.data() as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting payroll history from Firestore: $e');
      return [];
    }
  }
}
