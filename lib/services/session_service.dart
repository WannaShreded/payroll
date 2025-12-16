import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

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
}
