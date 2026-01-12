import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/user_session.dart';

class SessionService {
  static const String _userKey = 'user_session';
  static const String _emailKey = 'remembered_email';
  static const String _rememberKey = 'remember_me';

  // Save user session
  static Future<void> saveUserSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  // Get user session
  static Future<UserModel?> getUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        return UserModel.fromJson(userData);
      }
    } catch (e) {
      print('Error getting user session: $e');
    }
    return null;
  }

  // Save remembered email
  static Future<void> saveRememberedEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
    } catch (e) {
      print('Error saving remembered email: $e');
    }
  }

  // Get remembered email
  static Future<String?> getRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error getting remembered email: $e');
    }
    return null;
  }

  // Save remember me preference
  static Future<void> setRememberMe(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberKey, value);
    } catch (e) {
      print('Error setting remember me: $e');
    }
  }

  // Get remember me preference
  static Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberKey) ?? false;
    } catch (e) {
      print('Error getting remember me: $e');
      return false;
    }
  }

  // Update user session
  static Future<bool> updateUserSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
      return true;
    } catch (e) {
      print('Error updating user session: $e');
      return false;
    }
  }

  // Logout - clear session
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Clear all login data
  static Future<void> clearAllLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_emailKey);
      await prefs.remove(_rememberKey);
    } catch (e) {
      print('Error clearing login data: $e');
    }
  }

  // --- Helper methods to bridge with UserSession model ---
  static Future<UserSession?> getPrimitiveSession() async {
    final user = await getUserSession();
    if (user == null) return null;
    return UserSession(
      id: user.id,
      name: user.fullName,
      email: user.email,
      phone: user.phone,
      role: user.role,
      createdAt: user.createdAt.toIso8601String(),
    );
  }

  static Future<bool> saveUserSessionPrimitive(UserSession session) async {
    try {
      final user = UserModel(
        id: session.id,
        fullName: session.name,
        email: session.email,
        phone: session.phone,
        role: session.role,
        createdAt: session.createdAt != null ? DateTime.parse(session.createdAt!) : DateTime.now(),
      );
      await saveUserSession(user);
      return true;
    } catch (e) {
      print('Error saving primitive session: $e');
      return false;
    }
  }

  static Future<void> clearPrimitiveSession() async {
    await clearAllLoginData();
  }
}
