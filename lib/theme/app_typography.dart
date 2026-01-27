import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized Typography System for Payroll App
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // FONT FAMILIES
  static const String primaryFont = 'Roboto'; // System default

  // TITLE STYLES (20-24px, Bold)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  // SUBTITLE STYLES (16-18px, SemiBold)
  static const TextStyle subtitleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static const TextStyle subtitleMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle subtitleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // BODY STYLES (14px, Regular)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // CAPTION STYLES (12px, Regular)
  static const TextStyle captionLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // SPECIAL STYLES
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // BUTTON STYLES (for use in ButtonThemeData)
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  // STAT VALUE STYLE (for Report cards)
  static const TextStyle statValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.3,
  );

  // INPUT LABEL
  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.5,
    letterSpacing: 0.25,
  );

  // ERROR TEXT
  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
    letterSpacing: 0.4,
  );
}
