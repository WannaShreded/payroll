import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/employee_model.dart';

class EmployeeService {
  static const String _employeesKey = 'employees';

  // Get all employees
  static Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employeesJson = prefs.getStringList(_employeesKey) ?? [];
      return employeesJson
          .map((json) => EmployeeModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error getting employees: $e');
      return [];
    }
  }

  // Add new employee
  static Future<bool> addEmployee(EmployeeModel employee) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employees = await getAllEmployees();
      employees.add(employee);
      
      final employeesJson = employees
          .map((emp) => jsonEncode(emp.toJson()))
          .toList();
      
      await prefs.setStringList(_employeesKey, employeesJson);
      return true;
    } catch (e) {
      print('Error adding employee: $e');
      return false;
    }
  }

  // Update employee
  static Future<bool> updateEmployee(EmployeeModel employee) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employees = await getAllEmployees();
      
      final index = employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        employees[index] = employee;
        
        final employeesJson = employees
            .map((emp) => jsonEncode(emp.toJson()))
            .toList();
        
        await prefs.setStringList(_employeesKey, employeesJson);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating employee: $e');
      return false;
    }
  }

  // Delete employee
  static Future<bool> deleteEmployee(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employees = await getAllEmployees();
      
      employees.removeWhere((e) => e.id == id);
      
      final employeesJson = employees
          .map((emp) => jsonEncode(emp.toJson()))
          .toList();
      
      await prefs.setStringList(_employeesKey, employeesJson);
      return true;
    } catch (e) {
      print('Error deleting employee: $e');
      return false;
    }
  }

  // Get employee by ID
  static Future<EmployeeModel?> getEmployeeById(String id) async {
    try {
      final employees = await getAllEmployees();
      return employees.firstWhere((e) => e.id == id);
    } catch (e) {
      print('Error getting employee: $e');
      return null;
    }
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
