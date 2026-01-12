import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';

class EmployeeService {
  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference get _col => _firestore.collection('employees');

  // Get all employees
  static Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      final snap = await _col.get();
      return snap.docs
          .map((d) => EmployeeModel.fromJson(Map<String, dynamic>.from(d.data() as Map)))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting employees from Firestore: $e');
      return [];
    }
  }

  // Add new employee (uses provided id)
  static Future<bool> addEmployee(EmployeeModel employee) async {
    try {
      await _col.doc(employee.id).set(employee.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error adding employee to Firestore: $e');
      return false;
    }
  }

  // Update employee
  static Future<bool> updateEmployee(EmployeeModel employee) async {
    try {
      final docRef = _col.doc(employee.id);
      final doc = await docRef.get();
      if (!doc.exists) return false;
      await docRef.update(employee.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating employee in Firestore: $e');
      return false;
    }
  }

  // Delete employee
  static Future<bool> deleteEmployee(String id) async {
    try {
      await _col.doc(id).delete();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting employee from Firestore: $e');
      return false;
    }
  }

  // Get employee by ID
  static Future<EmployeeModel?> getEmployeeById(String id) async {
    try {
      final doc = await _col.doc(id).get();
      if (!doc.exists) return null;
      return EmployeeModel.fromJson(Map<String, dynamic>.from(doc.data() as Map));
    } catch (e) {
      // ignore: avoid_print
      print('Error getting employee from Firestore: $e');
      return null;
    }
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
