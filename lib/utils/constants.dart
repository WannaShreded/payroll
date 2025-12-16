import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGradientStart = Color(0xFF667eea);
  static const Color primaryGradientEnd = Color(0xFF764ba2);
  static const Color white = Colors.white;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color white70 = Colors.white70;
}

class AppConstants {
  static const List<String> roles = ['Admin', 'Manager', 'Staff'];
  static const int passwordMinLength = 8;
  static const int phoneMinLength = 10;
  static const int nameMinLength = 3;
  static const int registrationDelaySeconds = 2;
  static const int loginDelaySeconds = 2;
  static const int redirectDelaySeconds = 1;
}

class AppText {
  // Register Page
  static const String createAccount = 'Buat Akun';
  static const String registerSubtitle = 'Daftar untuk memulai';
  static const String fullName = 'Nama Lengkap';
  static const String email = 'Email';
  static const String phoneNumber = 'No. Telepon';
  static const String role = 'Jabatan/Role';
  static const String password = 'Password';
  static const String confirmPassword = 'Konfirmasi Password';
  static const String agreeTerms = 'Setuju dengan syarat & ketentuan';
  static const String register = 'Daftar';
  static const String alreadyHaveAccount = 'Sudah punya akun? ';
  static const String login = 'Login';
  static const String successRegister = 'Pendaftaran berhasil!';
  static const String agreeTermsError = 'Silakan setujui syarat & ketentuan';

  // Login Page
  static const String loginTitle = 'Login';
  static const String rememberMe = 'Ingat Saya';
  static const String forgotPassword = 'Lupa Password?';
  static const String dontHaveAccount = 'Belum punya akun? ';
  static const String signUp = 'Daftar';
  static const String loginButton = 'Login';
  static const String successLogin = 'Login berhasil!';
  static const String invalidCredentials = 'Email atau password salah';
  static const String loginSubtitle = 'Masuk ke akun Anda';

  // Dashboard Page
  static const String dashboard = 'Dashboard';
  static const String welcome = 'Selamat Datang!';
  static const String accountInfo = 'Informasi Akun';
  static const String name = 'Nama';
  static const String salary = 'Lihat Gaji';
  static const String quickActions = 'Aksi Cepat';

  // General
  static const String comingSoon = 'Coming Soon';
}

