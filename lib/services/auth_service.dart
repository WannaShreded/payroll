import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';

import '../models/user_model.dart';
import '../models/user_session.dart';
import 'session_service.dart';

class AuthService {
  static const String _usersKey = 'auth_users';

  // Internal: load stored user records (they include hashed password)
  static Future<List<Map<String, dynamic>>> _loadUserRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_usersKey) ?? [];
      return list.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error loading user records: $e');
      return [];
    }
  }

  static Future<bool> _saveUserRecords(List<Map<String, dynamic>> records) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = records.map((r) => jsonEncode(r)).toList();
      await prefs.setStringList(_usersKey, list);
      return true;
    } catch (e) {
      print('Error saving user records: $e');
      return false;
    }
  }

  // Register flow
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    // 1. Validate input
    if (!EmailValidator.validate(email)) return false;
    if (password.length < 8) return false;

    final records = await _loadUserRecords();

    // 2. Check existing
    final exists = records.any((r) => (r['email'] ?? '').toString().toLowerCase() == email.toLowerCase());
    if (exists) return false;

    // 3. Hash password
    final hashed = sha256.convert(utf8.encode(password)).toString();

    // 4. Create record and save
    final id = 'USER-${DateTime.now().millisecondsSinceEpoch}';
    final createdAt = DateTime.now().toIso8601String();
    final record = {
      'id': id,
      'fullName': name,
      'email': email,
      'phone': phone,
      'role': role,
      'password': hashed,
      'createdAt': createdAt,
    };

    records.add(record);
    return await _saveUserRecords(records);
  }

  // Login flow
  static Future<UserSession?> loginUser({
    required String email,
    required String password,
  }) async {
    final records = await _loadUserRecords();
    final record = records.firstWhere(
      (r) => (r['email'] ?? '').toString().toLowerCase() == email.toLowerCase(),
      orElse: () => {},
    );

    if (record.isEmpty) return null;

    final hashed = sha256.convert(utf8.encode(password)).toString();
    if ((record['password'] ?? '') != hashed) return null;

    // Build UserModel and save session via SessionService
    final userMap = Map<String, dynamic>.from(record);
    // Remove password before building UserModel
    userMap.remove('password');

    final user = UserModel.fromJson(userMap);
    await SessionService.saveUserSession(user);

    // Also save primitive UserSession for convenience
    final session = UserSession(
      id: user.id,
      name: user.fullName,
      email: user.email,
      phone: user.phone,
      role: user.role,
      createdAt: user.createdAt.toIso8601String(),
    );
    await session.saveSession();

    return session;
  }

  // Logout flow
  static Future<void> logoutUser() async {
    await SessionService.logout();
    await UserSession.clearSession();
  }
}
