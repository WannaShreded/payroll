import 'package:flutter/material.dart';

/// Centralized Spacing & Dimensions System for Payroll App
class AppDimensions {
  // Prevent instantiation
  AppDimensions._();

  // SPACING VALUES
  static const double spacing0 = 0;
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing28 = 28;
  static const double spacing32 = 32;
  static const double spacing36 = 36;
  static const double spacing40 = 40;
  static const double spacing48 = 48;

  // BORDER RADIUS VALUES
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXL = 20;
  static const double radiusCircle = 50; // For circle/pill shapes

  // BUTTON DIMENSIONS
  static const double buttonHeightLarge = 52;
  static const double buttonHeightMedium = 48;
  static const double buttonHeightSmall = 40;
  static const double buttonHeightXSmall = 36;

  static const double buttonPaddingHorizontal = 24;
  static const double buttonPaddingVertical = 12;

  // INPUT/TEXTFIELD DIMENSIONS
  static const double inputHeightLarge = 56;
  static const double inputHeightMedium = 48;
  static const double inputHeightSmall = 40;

  static const double inputPaddingHorizontal = 16;
  static const double inputPaddingVertical = 12;

  // CARD DIMENSIONS
  static const double cardPadding = 16;
  static const double cardPaddingLarge = 20;
  static const double cardPaddingSmall = 12;

  // ICON SIZES
  static const double iconXSmall = 16;
  static const double iconSmall = 20;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;
  static const double iconXXLarge = 64;
  static const double iconHuge = 80;
  static const double iconGiant = 100;

  // AVATAR SIZES
  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 80;
  static const double avatarXLarge = 100;

  // ELEVATION/SHADOW
  static const double elevationSmall = 2;
  static const double elevationMedium = 4;
  static const double elevationLarge = 8;
  static const double elevationXL = 12;

  // DIVIDER HEIGHT
  static const double dividerThickness = 1;
  static const double dividerThicknessStrong = 2;

  // BOTTOM SHEET HEIGHT
  static const double bottomSheetRadiusTop = 20;

  // LIST TILE HEIGHT
  static const double listTileHeight = 56;
  static const double listTileDenseHeight = 48;

  // APP BAR HEIGHT
  static const double appBarHeight = 56;
  static const double appBarHeightLarge = 64;

  // BORDER WIDTH
  static const double borderWidthThin = 1;
  static const double borderWidthMedium = 2;
  static const double borderWidthStrong = 3;

  // MIN TOUCH TARGET SIZE
  static const double minTouchTarget = 48;

  // SNACKBAR & TOAST
  static const double snackBarHeight = 48;
  static const double snackBarElevation = 6;

  // DIALOG
  static const double dialogMaxWidth = 400;
  static const double dialogMinWidth = 280;

  // SCREEN BREAKPOINTS
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  // CORNER RADIUS PRESETS (EdgeInsets style)
  static const BorderRadius radiusSmallBorderRadius = BorderRadius.all(
    Radius.circular(radiusSmall),
  );

  static const BorderRadius radiusMediumBorderRadius = BorderRadius.all(
    Radius.circular(radiusMedium),
  );

  static const BorderRadius radiusLargeBorderRadius = BorderRadius.all(
    Radius.circular(radiusLarge),
  );

  static const BorderRadius radiusTopBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(radiusLarge),
    topRight: Radius.circular(radiusLarge),
  );

  // PADDING PRESETS
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacing12);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacing24);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: spacing8,
  );
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: spacing12,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: spacing16,
  );

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: spacing8,
  );
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(
    vertical: spacing12,
  );
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(
    vertical: spacing16,
  );

  static const EdgeInsets paddingCardSmall = EdgeInsets.all(cardPaddingSmall);
  static const EdgeInsets paddingCard = EdgeInsets.all(cardPadding);
  static const EdgeInsets paddingCardLarge = EdgeInsets.all(cardPaddingLarge);

  // SHADOW PRESETS
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: Color(0x26000000), // 15% black
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}
