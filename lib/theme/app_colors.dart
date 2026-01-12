import 'package:flutter/material.dart';

/// Centralized Color System for Payroll App
class AppColors {
  // Prevent instantiation
  AppColors._();

  // PRIMARY GRADIENT
  static const Color primaryStart = Color(0xFF667eea);
  static const Color primaryEnd = Color(0xFF764ba2);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryStart, primaryEnd],
  );

  // BACKGROUNDS
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color overlayBackground = Color(0xFF000000);

  // TEXT COLORS
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // SEMANTIC COLORS
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // STAT CARD COLORS (for Report Page)
  static const Color statBlue = Color(0xFF3B82F6);
  static const Color statGreen = Color(0xFF10B981);
  static const Color statOrange = Color(0xFFF59E0B);
  static const Color statPurple = Color(0xFF8B5CF6);

  // BORDER & DIVIDER
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFCBD5E1);

  // DISABLED STATE
  static const Color disabledBackground = Color(0xFFF1F5F9);
  static const Color disabledText = Color(0xFFA0AEC0);

  // UTILITY
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // STATUS BADGE
  static const Color activeBadge = Color(0xFFDEFCF0);
  static const Color activeText = Color(0xFF047857);
  static const Color inactiveBadge = Color(0xFFFEE2E2);
  static const Color inactiveText = Color(0xDC2626);
}
