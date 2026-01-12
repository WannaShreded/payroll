import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? createdAt;

  UserSession({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.createdAt,
  });

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);
    await prefs.setString('userRole', role);
    if (createdAt != null) {
      await prefs.setString('userCreatedAt', createdAt!);
    }
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<UserSession?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return null;

    return UserSession(
      id: prefs.getString('userId') ?? '',
      name: prefs.getString('userName') ?? '',
      email: prefs.getString('userEmail') ?? '',
      phone: prefs.getString('userPhone') ?? '',
      role: prefs.getString('userRole') ?? '',
      createdAt: prefs.getString('userCreatedAt'),
    );
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');
    await prefs.remove('userRole');
    await prefs.remove('userCreatedAt');
    await prefs.remove('isLoggedIn');
  }
}
