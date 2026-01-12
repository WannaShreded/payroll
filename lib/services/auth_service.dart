import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import '../models/user_model.dart';
import '../models/user_session.dart';
import 'session_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  // Register using FirebaseAuth + create user profile in Firestore.
  // Before: stored hashed passwords in SharedPreferences (insecure and local-only).
  // After: use Firebase Auth to manage credentials and Firestore to store profile.
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    if (!EmailValidator.validate(email)) return false;
    if (password.length < 8) return false;

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;

      final userModel = UserModel(
        id: uid,
        fullName: name,
        email: email,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );

      // Save profile in Firestore under `users/{uid}`
      await _firestore.collection('users').doc(uid).set(userModel.toJson());

      return true;
    } on FirebaseAuthException catch (e) {
      // Handle auth-specific errors (email-already-in-use, weak-password, etc.)
      // ignore: avoid_print
      print('FirebaseAuth register error: ${e.code} ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Register error: $e');
      return false;
    }
  }

  // Login using FirebaseAuth, then load profile from Firestore and save session
  static Future<UserSession?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final userMap = doc.data()!;
      final user = UserModel.fromJson(Map<String, dynamic>.from(userMap));

      // Save local session (keeps app behavior compatible)
      await SessionService.saveUserSession(user);

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
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('FirebaseAuth login error: ${e.code} ${e.message}');
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Login error: $e');
      return null;
    }
  }

  // Logout using FirebaseAuth and clear local session
  static Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print('FirebaseAuth signOut error: $e');
    }
    await SessionService.logout();
    await UserSession.clearSession();
  }
}
