import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGradientStart = Color(0xFF667eea);
  static const Color primaryGradientEnd = Color(0xFF764ba2);
  static const Color white = Colors.white;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color white70 = Colors.white70;
  static const Color orange = Color(0xFFFF9500);
  static const Color teal = Color(0xFF00C9A7);
  static const Color red = Color(0xFFFF4757);
  static const Color blue = Color(0xFF2E86AB);
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
  static const String goodMorning = 'Selamat Pagi';
  static const String goodAfternoon = 'Selamat Siang';
  static const String goodEvening = 'Selamat Sore';
  static const String goodNight = 'Selamat Malam';
  static const String totalEmployees = 'Total Karyawan';
  static const String totalSalary = 'Total Gaji Bulan Ini';
  static const String employeeData = 'Data Karyawan';
  static const String payroll = 'Penggajian';
  static const String attendance = 'Absensi';
  static const String reports = 'Laporan';
  static const String home = 'Beranda';
  static const String employees = 'Karyawan';
  static const String salary = 'Gaji';
  static const String profile = 'Profil';
  static const String accountInfo = 'Informasi Akun';
  static const String name = 'Nama';
  static const String quickActions = 'Aksi Cepat';
  static const String notifications = 'Notifikasi';

  // General
  static const String comingSoon = 'Coming Soon';
}

class GreetingMessage {
  static String getGreeting(int hour) {
    if (hour >= 0 && hour < 12) {
      return AppText.goodMorning;
    } else if (hour >= 12 && hour < 15) {
      return AppText.goodAfternoon;
    } else if (hour >= 15 && hour < 19) {
      return AppText.goodEvening;
    } else {
      return AppText.goodNight;
    }
  }
}


