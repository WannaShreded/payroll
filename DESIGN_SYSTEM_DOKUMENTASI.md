# 🎨 DESIGN SYSTEM - PAYROLL APP

**Versi:** 1.0  
**Status:** ✅ IMPLEMENTATION COMPLETE  
**Tanggal:** 10 Januari 2026

---

## 📖 OVERVIEW

Complete design system dengan color, typography, spacing, dan component dimensions yang konsisten di seluruh aplikasi.

### File Structure:
```
lib/theme/
├── app_colors.dart          # Color constants & palette
├── app_typography.dart      # Text styles & typography
├── app_dimensions.dart      # Spacing, sizes, elevations
├── app_theme.dart           # Main ThemeData configuration
└── index.dart              # Barrel export file
```

---

## 🎨 COLOR SYSTEM

File: `lib/theme/app_colors.dart`

### Primary Gradient
```dart
primaryStart: #667eea (Purple)
primaryEnd: #764ba2 (Dark Purple)
primaryGradient: LinearGradient (top-left to bottom-right)
```

**Penggunaan:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

### Background Colors
- `backgroundLight: #f5f7fa` - Main background
- `cardBackground: #ffffff` - Card surfaces
- `overlayBackground: #000000` - For modals/overlays

### Text Colors
- `textPrimary: #2d3748` - Main text
- `textSecondary: #64748b` - Secondary text
- `textTertiary: #94a3b8` - Tertiary/disabled text
- `textInverse: #ffffff` - Text on dark/gradient backgrounds

### Semantic Colors
- `success: #10b981` - Green success state
- `error: #ef4444` - Red error state
- `warning: #f59e0b` - Amber warning state
- `info: #3b82f6` - Blue info state

### Stat Card Colors (Report Page)
- `statBlue: #3b82f6` - For employee stats
- `statGreen: #10b981` - For salary stats
- `statOrange: #f59e0b` - For average stats
- `statPurple: #8b5cf6` - For attendance stats

### Border & Divider Colors
- `borderLight: #e2e8f0` - Light borders
- `dividerLight: #cbd5e1` - Light dividers

### Status Badge Colors
- `activeBadge: #defcf0` - Green background for active
- `activeText: #047857` - Green text for active
- `inactiveBadge: #fee2e2` - Red background for inactive
- `inactiveText: #dc2626` - Red text for inactive

---

## 📝 TYPOGRAPHY SYSTEM

File: `lib/theme/app_typography.dart`

### Title Styles (20-24px, Bold)
```dart
titleLarge    → 24px, Bold  (h1)
titleMedium   → 22px, Bold  (h2)
titleSmall    → 20px, Bold  (h3)
```

**Penggunaan:**
```dart
Text('Main Title', style: AppTypography.titleLarge)
```

### Subtitle Styles (16-18px, SemiBold)
```dart
subtitleLarge   → 18px, SemiBold  (h4)
subtitleMedium  → 17px, SemiBold  (h5)
subtitleSmall   → 16px, SemiBold  (h6)
```

### Body Styles (14px, Regular)
```dart
bodyLarge   → 16px, Medium    (subtitle/emphasis)
bodyMedium  → 14px, Regular   (default body text)
bodySmall   → 13px, Regular   (secondary body)
```

### Caption Styles (12px, Regular)
```dart
captionLarge  → 12px, Medium   (labels/hints)
captionSmall  → 11px, Regular  (meta text)
```

### Special Styles
```dart
labelMedium       → 13px, SemiBold  (form labels)
labelSmall        → 12px, Medium    (secondary labels)
buttonLarge       → 16px, Bold      (button text)
buttonMedium      → 14px, Bold      (button text)
buttonSmall       → 12px, Bold      (button text)
statValue         → 28px, Bold      (report stat values)
statLabel         → 13px, Medium    (report stat labels)
inputLabel        → 13px, SemiBold  (form input labels)
inputHint         → 14px, Regular   (form hints)
errorText         → 12px, Medium    (error messages)
```

**Penggunaan:**
```dart
Text('Body text', style: AppTypography.bodyMedium)
Text('Error', style: AppTypography.errorText)
Text('Stat Value', style: AppTypography.statValue)
```

---

## 📏 SPACING & DIMENSIONS SYSTEM

File: `lib/theme/app_dimensions.dart`

### Spacing Scale
```dart
spacing0  → 0px
spacing2  → 2px
spacing4  → 4px
spacing8  → 8px    ⭐ Common
spacing12 → 12px   ⭐ Common
spacing16 → 16px   ⭐ Common
spacing20 → 20px   ⭐ Common
spacing24 → 24px   ⭐ Common
spacing32 → 32px
spacing40 → 40px
spacing48 → 48px
```

**Penggunaan:**
```dart
SizedBox(height: AppDimensions.spacing16)
Padding(
  padding: const EdgeInsets.all(AppDimensions.spacing12),
  child: ...
)
```

### Border Radius
```dart
radiusSmall   → 8px    (small buttons)
radiusMedium  → 12px   ⭐ Standard (cards, inputs)
radiusLarge   → 16px   (dialogs, sheets)
radiusXL      → 20px   (full-width modals)
radiusCircle  → 50px   (circles, pills)
```

**Penggunaan:**
```dart
ClipRRect(
  borderRadius: AppDimensions.radiusMediumBorderRadius,
  child: ...
)
```

### Component Heights
```dart
// Buttons
buttonHeightLarge   → 52px
buttonHeightMedium  → 48px  ⭐ Standard
buttonHeightSmall   → 40px
buttonHeightXSmall  → 36px

// Input Fields
inputHeightLarge    → 56px
inputHeightMedium   → 48px  ⭐ Standard
inputHeightSmall    → 40px
```

### Icon Sizes
```dart
iconXSmall   → 16px
iconSmall    → 20px
iconMedium   → 24px  ⭐ Standard
iconLarge    → 32px
iconXLarge   → 48px
iconHuge     → 80px
iconGiant    → 100px
```

### Avatar Sizes
```dart
avatarSmall   → 32px
avatarMedium  → 48px
avatarLarge   → 80px
avatarXLarge  → 100px  ⭐ Profile page
```

### Elevation & Shadows
```dart
elevationSmall   → 2px   ⭐ Cards
elevationMedium  → 4px   ⭐ Standard
elevationLarge   → 8px   ⭐ Dialogs
elevationXL      → 12px  (bottom sheets)

// Shadow Presets
shadowSmall   → BlurRadius 2,  Offset(0,1)
shadowMedium  → BlurRadius 4,  Offset(0,2)  ⭐ Standard
shadowLarge   → BlurRadius 8,  Offset(0,4)
shadowXL      → BlurRadius 12, Offset(0,6)
```

**Penggunaan:**
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppDimensions.radiusMediumBorderRadius,
    boxShadow: AppDimensions.shadowMedium,
  ),
)
```

### Padding Presets (Pre-configured EdgeInsets)
```dart
paddingSmall     → all(8px)
paddingMedium    → all(12px)
paddingLarge     → all(16px)
paddingXLarge    → all(24px)

paddingHorizontalSmall   → symmetric(h: 8px)
paddingHorizontalMedium  → symmetric(h: 12px)
paddingHorizontalLarge   → symmetric(h: 16px)

paddingVerticalSmall     → symmetric(v: 8px)
paddingVerticalMedium    → symmetric(v: 12px)
paddingVerticalLarge     → symmetric(v: 16px)

paddingCard      → all(16px)
paddingCardLarge → all(20px)
```

**Penggunaan:**
```dart
Container(
  padding: AppDimensions.paddingLarge,
  child: ...
)
```

### Breakpoints (for responsive design)
```dart
mobileBreakpoint   → 480px
tabletBreakpoint   → 768px
desktopBreakpoint  → 1024px
```

---

## 🎯 THEME DATA CONFIGURATION

File: `lib/theme/app_theme.dart`

Main `AppTheme.lightTheme` mencakup:

### ✅ Color Scheme
```dart
primary: AppColors.primaryStart
secondary: AppColors.primaryEnd
surface: AppColors.cardBackground
background: AppColors.backgroundLight
error: AppColors.error
```

### ✅ Component Themes
- **AppBar** - White background, left-aligned title, medium elevation
- **Cards** - White background, small shadow, medium border radius
- **Buttons** - Gradient primary, 48px height, medium radius
- **Text Fields** - Light background, bordered, focused state
- **Input Decoration** - Pre-configured with validation states
- **Bottom Navigation** - White background, purple selected color
- **Dialogs** - Large border radius, medium shadow
- **Snackbars** - Dark background, floating behavior

### ✅ Helper Methods
```dart
// Semantic button styles
AppTheme.successButtonStyle()   // Green button
AppTheme.errorButtonStyle()     // Red button
AppTheme.warningButtonStyle()   // Orange button
AppTheme.ghostButtonStyle()     // Transparent with border

// Decorations
AppTheme.gradientButtonDecoration()  // For gradient buttons
AppTheme.cardDecoration()            // For styled cards
```

---

## 💻 USAGE EXAMPLES

### Example 1: Styled Card
```dart
Container(
  padding: AppDimensions.paddingLarge,
  decoration: AppTheme.cardDecoration(),
  child: Column(
    children: [
      Text('Card Title', style: AppTypography.titleSmall),
      SizedBox(height: AppDimensions.spacing12),
      Text('Card content', style: AppTypography.bodyMedium),
    ],
  ),
)
```

### Example 2: Primary Button
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Save', style: AppTypography.buttonMedium),
)
```

### Example 3: Form Input
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    labelStyle: AppTypography.inputLabel,
    hintText: 'Enter your email',
    hintStyle: AppTypography.inputHint,
  ),
)
```

### Example 4: Stat Display (Report Page)
```dart
Text(
  'Rp 50.000.000',
  style: AppTypography.statValue,
)
Text(
  'Total Gaji Bulan Ini',
  style: AppTypography.statLabel,
)
```

### Example 5: Gradient Container
```dart
Container(
  decoration: AppTheme.gradientButtonDecoration(),
  padding: AppDimensions.paddingLarge,
  child: Text('Gradient Content', style: AppTypography.bodyMedium),
)
```

### Example 6: Status Badge
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppDimensions.spacing8,
    vertical: AppDimensions.spacing4,
  ),
  decoration: BoxDecoration(
    color: AppColors.activeBadge,
    borderRadius: AppDimensions.radiusSmallBorderRadius,
  ),
  child: Text(
    'Aktif',
    style: AppTypography.captionLarge.copyWith(
      color: AppColors.activeText,
    ),
  ),
)
```

### Example 7: Icon with Spacing
```dart
Row(
  children: [
    Icon(Icons.person, 
      size: AppDimensions.iconMedium,
      color: AppColors.primaryStart,
    ),
    SizedBox(width: AppDimensions.spacing12),
    Text('Profile', style: AppTypography.bodyMedium),
  ],
)
```

---

## 🔄 MIGRATION GUIDE

Jika ada kode lama yang belum menggunakan design system:

### Before (Old Style)
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 4)],
  ),
  child: Text(
    'Title',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2D3748),
    ),
  ),
)
```

### After (Design System)
```dart
Container(
  padding: AppDimensions.paddingLarge,
  decoration: AppTheme.cardDecoration(),
  child: Text('Title', style: AppTypography.titleSmall),
)
```

---

## ✅ IMPLEMENTATION CHECKLIST

- ✅ Color System (26 color constants + gradient)
- ✅ Typography System (15+ text styles)
- ✅ Spacing Scale (14 spacing values)
- ✅ Component Dimensions (button, input, icon, avatar sizes)
- ✅ Border Radius Presets (4 standard + circle)
- ✅ Elevation & Shadows (4 levels + presets)
- ✅ Padding Presets (12 pre-configured EdgeInsets)
- ✅ ThemeData Configuration (Material Design 3)
- ✅ Helper Methods (button styles, decorations)
- ✅ Integration dengan main.dart

---

## 📚 FILE IMPORTS

```dart
// For colors
import 'package:payroll/theme/app_colors.dart';

// For typography
import 'package:payroll/theme/app_typography.dart';

// For dimensions
import 'package:payroll/theme/app_dimensions.dart';

// For theme
import 'package:payroll/theme/app_theme.dart';

// Or all at once
import 'package:payroll/theme/index.dart';
```

---

## 🎯 DESIGN TOKENS REFERENCE

| Category | Token | Value | Usage |
|----------|-------|-------|-------|
| **Color** | primaryStart | #667eea | Buttons, links, primary elements |
| | primaryEnd | #764ba2 | Gradient end, secondary elements |
| | success | #10b981 | Success states, checkmarks |
| | error | #ef4444 | Error states, validation |
| **Typography** | titleLarge | 24px Bold | Page titles |
| | bodyMedium | 14px Regular | Body text (default) |
| | captionSmall | 11px Regular | Meta text |
| **Spacing** | spacing16 | 16px | Standard padding/margin |
| | spacing12 | 12px | Secondary spacing |
| | spacing24 | 24px | Large spacing |
| **Components** | buttonHeightMedium | 48px | Standard button height |
| | radiusMedium | 12px | Standard border radius |
| | elevationMedium | 4px | Standard card shadow |

---

## 🚀 BEST PRACTICES

1. **Always use design system constants**, jangan hardcode values
2. **Use predefined text styles**, jangan create custom TextStyle
3. **Use spacing scale**, jangan arbitrary padding/margin
4. **Use color constants**, jangan Color(0xFF...)
5. **Use presets** seperti paddingLarge, shadowMedium, radiusMediumBorderRadius
6. **Maintain consistency** di semua screens

---

**Dokumentasi Design System:** Lengkap ✅  
**Status Implementasi:** Production Ready 🚀  
**Last Updated:** 10 Januari 2026
