import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized Typography System for Payroll App
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  // FONT FAMILIES
  static const String primaryFont = 'Roboto'; // System default

  // TITLE STYLES (20-24px, Bold)
  static final TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static final TextStyle titleMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static final TextStyle titleSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  // SUBTITLE STYLES (16-18px, SemiBold)
  static final TextStyle subtitleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.15,
  );

  static final TextStyle subtitleMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static final TextStyle subtitleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // BODY STYLES (14px, Regular)
  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // CAPTION STYLES (12px, Regular)
  static final TextStyle captionLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static final TextStyle captionSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // SPECIAL STYLES
  static final TextStyle labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // BUTTON STYLES (for use in ButtonThemeData)
  static final TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
    letterSpacing: 0.5,
  );

  // STAT VALUE STYLE (for Report cards)
  static final TextStyle statValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static final TextStyle statLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.3,
  );

  // INPUT LABEL
  static final TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static final TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.5,
    letterSpacing: 0.25,
  );

  // ERROR TEXT
  static final TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
    letterSpacing: 0.4,
  );
}
