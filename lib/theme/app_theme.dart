import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

/// Main ThemeData configuration for the Payroll App
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // COLOR SCHEME
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryStart,
        secondary: AppColors.primaryEnd,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        outline: AppColors.borderLight,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
      ),

      // SCAFFOLDBACKGROUND
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // APP BAR THEME
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        titleTextStyle: AppTypography.titleSmall,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppDimensions.iconMedium,
        ),
      ),

      // CARD THEME
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppDimensions.elevationSmall,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
        ),
      ),

      // ELEVATED BUTTON THEME
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryStart,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          minimumSize: const Size(
            AppDimensions.spacing0,
            AppDimensions.buttonHeightMedium,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.radiusMediumBorderRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // TEXT BUTTON THEME
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryStart,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
            vertical: AppDimensions.spacing8,
          ),
          minimumSize: const Size(
            AppDimensions.spacing0,
            AppDimensions.buttonHeightSmall,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // OUTLINED BUTTON THEME
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryStart,
          side: const BorderSide(
            color: AppColors.primaryStart,
            width: AppDimensions.borderWidthThin,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          minimumSize: const Size(
            AppDimensions.spacing0,
            AppDimensions.buttonHeightMedium,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.radiusMediumBorderRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // INPUT DECORATION THEME
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingHorizontal,
          vertical: AppDimensions.inputPaddingVertical,
        ),
        isDense: false,
        border: const OutlineInputBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
          borderSide: BorderSide(
            color: AppColors.borderLight,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
          borderSide: BorderSide(
            color: AppColors.borderLight,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
          borderSide: BorderSide(
            color: AppColors.primaryStart,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        labelStyle: AppTypography.inputLabel,
        hintStyle: AppTypography.inputHint,
        helperStyle: AppTypography.captionSmall.copyWith(
          color: AppColors.textSecondary,
        ),
        errorStyle: AppTypography.errorText,
      ),

      // TEXT THEME
      textTheme: const TextTheme(
        displayLarge: AppTypography.titleLarge,
        displayMedium: AppTypography.titleMedium,
        displaySmall: AppTypography.titleSmall,
        headlineLarge: AppTypography.subtitleLarge,
        headlineMedium: AppTypography.subtitleMedium,
        headlineSmall: AppTypography.subtitleSmall,
        titleLarge: AppTypography.bodyLarge,
        titleMedium: AppTypography.bodyMedium,
        titleSmall: AppTypography.bodySmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelMedium,
        labelMedium: AppTypography.labelSmall,
        labelSmall: AppTypography.captionSmall,
      ),

      // ICON THEME
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconMedium,
      ),

      // CHECKBOX THEME
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryStart;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.borderLight),
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusSmallBorderRadius,
        ),
      ),

      // RADIO THEME
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryStart;
          }
          return AppColors.borderLight;
        }),
      ),

      // SWITCH THEME
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryStart;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryStart.withAlpha(128);
          }
          return AppColors.borderLight;
        }),
      ),

      // SLIDER THEME
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primaryStart,
        inactiveTrackColor: AppColors.borderLight,
        thumbColor: AppColors.primaryStart,
        valueIndicatorColor: AppColors.primaryStart,
      ),

      // BOTTOM NAVIGATION THEME
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        selectedItemColor: AppColors.primaryStart,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // SNACKBAR THEME
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        elevation: AppDimensions.snackBarElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusMediumBorderRadius,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // DIALOG THEME
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.cardBackground,
        elevation: AppDimensions.elevationLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusLargeBorderRadius,
        ),
        titleTextStyle: AppTypography.titleSmall,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // DIVIDER THEME
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: AppDimensions.dividerThickness,
        space: AppDimensions.spacing16,
      ),

      // LIST TILE THEME
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textSecondary,
        tileColor: AppColors.white,
        selectedTileColor: AppColors.backgroundLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing8,
        ),
        minVerticalPadding: AppDimensions.spacing8,
      ),

      // PROGRESS INDICATOR THEME
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryStart,
        linearMinHeight: 4,
      ),

      // TOOLTIP THEME
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: AppDimensions.radiusSmallBorderRadius,
        ),
        textStyle: AppTypography.captionSmall.copyWith(color: AppColors.white),
      ),
    );
  }

  // CONVENIENCE METHODS FOR COMMON STYLES

  /// Success styled button
  static ButtonStyle successButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.buttonPaddingHorizontal,
        vertical: AppDimensions.buttonPaddingVertical,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.radiusMediumBorderRadius,
      ),
    );
  }

  /// Error styled button
  static ButtonStyle errorButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.buttonPaddingHorizontal,
        vertical: AppDimensions.buttonPaddingVertical,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.radiusMediumBorderRadius,
      ),
    );
  }

  /// Warning styled button
  static ButtonStyle warningButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.warning,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.buttonPaddingHorizontal,
        vertical: AppDimensions.buttonPaddingVertical,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.radiusMediumBorderRadius,
      ),
    );
  }

  /// Ghost button (transparent with border)
  static ButtonStyle ghostButtonStyle({Color? color}) {
    final borderColor = color ?? AppColors.primaryStart;
    return OutlinedButton.styleFrom(
      foregroundColor: borderColor,
      side: BorderSide(color: borderColor),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.buttonPaddingHorizontal,
        vertical: AppDimensions.buttonPaddingVertical,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.radiusMediumBorderRadius,
      ),
    );
  }

  /// Gradient button decoration
  static Decoration gradientButtonDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: borderRadius ?? AppDimensions.radiusMediumBorderRadius,
    );
  }

  /// Card with shadow
  static BoxDecoration cardDecoration({
    Color? backgroundColor,
    List<BoxShadow>? shadows,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.cardBackground,
      borderRadius: borderRadius ?? AppDimensions.radiusMediumBorderRadius,
      boxShadow: shadows ?? AppDimensions.shadowSmall,
    );
  }
}
