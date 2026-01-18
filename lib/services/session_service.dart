import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/user_session.dart';

class SessionService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  // Save user profile to Firestore and also keep a local copy for compatibility.
  static Future<void> saveUserSession(UserModel user) async {
    try {
      // Enforce role assignment: only Admin session users may set arbitrary roles.
      final sessionUser = await getUserSession();
      final data = Map<String, dynamic>.from(user.toJson());
      if (sessionUser == null || sessionUser.role != 'Admin') {
        // Non-admins cannot assign roles — default to 'Staff'
        data['role'] = 'Staff';
      }
      await _firestore.collection('users').doc(user.id).set(data);
    } catch (e) {
      // ignore: avoid_print
      print('Error saving user session to Firestore: $e');
    }
  }

  // Update existing user profile in Firestore. Returns true on success.
  static Future<bool> updateUserSession(UserModel user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.id);
      final doc = await docRef.get();
      if (!doc.exists) {
        return false;
      }
      // Prevent non-admin session users from changing roles.
      final sessionUser = await getUserSession();
      final data = Map<String, dynamic>.from(user.toJson());
      if (sessionUser == null || sessionUser.role != 'Admin') {
        data.remove('role');
      }
      await docRef.update(data);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error updating user session in Firestore: $e');
      return false;
    }
  }

  // Get user session: prefer Firebase Auth currentUser and Firestore profile
  static Future<UserModel?> getUserSession() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (!doc.exists) return null;
      return UserModel.fromJson(Map<String, dynamic>.from(doc.data() as Map));
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user session from Firestore: $e');
      return null;
    }
  }

  // Logout via FirebaseAuth
  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out: $e');
    }
  }

  // ---------------- Helper methods for compatibility ----------------
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
        createdAt: session.createdAt != null
            ? DateTime.parse(session.createdAt!)
            : DateTime.now(),
      );
      await saveUserSession(user);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error saving primitive session to Firestore: $e');
      return false;
    }
  }

  static Future<void> clearPrimitiveSession() async {
    await logout();
  }

  // --- Remember-me helpers using SharedPreferences (local-only) ---
  static const String _emailKey = 'remembered_email';
  static const String _rememberKey = 'remember_me';

  static Future<void> saveRememberedEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
    } catch (e) {
      // ignore: avoid_print
      print('Error saving remembered email: $e');
    }
  }

  static Future<String?> getRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      // ignore: avoid_print
      print('Error getting remembered email: $e');
      return null;
    }
  }

  static Future<void> setRememberMe(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberKey, value);
    } catch (e) {
      // ignore: avoid_print
      print('Error setting remember me: $e');
    }
  }

  static Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberKey) ?? false;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting remember me: $e');
      return false;
    }
  }

  static Future<void> clearAllLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_rememberKey);
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing login data: $e');
    }
  }
}
