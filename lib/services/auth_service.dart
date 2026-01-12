import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import '../models/user_model.dart';
import '../models/user_session.dart';
import 'session_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  /// Register a new user.
  /// Returns `null` on success, or a user-friendly error string on failure.
  static Future<String?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
  }) async {
    if (!EmailValidator.validate(email)) return 'Email tidak valid';
    if (password.length < 8) return 'Password minimal 8 karakter';

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
      try {
        await _firestore.collection('users').doc(uid).set(userModel.toJson());
      } catch (e) {
        // If Firestore write fails, delete the created Auth user to avoid orphaned accounts
        try {
          await userCred.user?.delete();
        } catch (delErr) {
          // ignore: avoid_print
          print('Failed to delete auth user after Firestore error: $delErr');
        }
        // ignore: avoid_print
        print('Firestore write error during registration: $e');
        return 'Pendaftaran gagal (gagal menyimpan profil). Coba lagi.';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar';
        case 'invalid-email':
          return 'Email tidak valid';
        case 'weak-password':
          return 'Password terlalu lemah';
        case 'operation-not-allowed':
          return 'Pendaftaran tidak diizinkan pada project ini';
        default:
          return e.message ?? 'Pendaftaran gagal';
      }
    } catch (e) {
      // ignore: avoid_print
      print('Register error: $e');
      return 'Pendaftaran gagal';
    }
  }

  /// Login and return a `UserSession` (or `null` on failure).
  static Future<UserSession?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      late final UserCredential userCred;
      try {
        userCred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // ignore: avoid_print
        print('signInWithEmailAndPassword returned type: ${userCred.runtimeType}');
        // ignore: avoid_print
        print('user runtimeType: ${userCred.user.runtimeType}');
        // ignore: avoid_print
        print('providerData runtimeType: ${userCred.user?.providerData.runtimeType}');
      } catch (e, st) {
        // Detailed logging for platform/channel type errors
        // ignore: avoid_print
        print('Error during signInWithEmailAndPassword: $e');
        // ignore: avoid_print
        print(st);
        rethrow;
      }

      final uid = userCred.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final raw = doc.data();
      // Defensive logging to help diagnose type issues (e.g., unexpected List)
      // ignore: avoid_print
      print('AuthService.loginUser - raw user doc type: ${raw.runtimeType}');
      if (raw is! Map<String, dynamic>) {
        // ignore: avoid_print
        print('Unexpected user doc format: $raw');
        return null;
      }

      final userMap = Map<String, dynamic>.from(raw);
      final user = UserModel.fromJson(userMap);

      // Save local session for compatibility
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

  /// Logout user from Firebase and clear local session
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

