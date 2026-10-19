import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/dimensions.dart';
import '../tokens/typography.dart';

class DSTheme {
  DSTheme._();

  static ThemeData lightTheme = _build(
    brightness: Brightness.light,
    background: DsColors.background,
    surface: DsColors.white,
    onSurface: DsColors.grey90,
  );

  static ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    background: DsColors.darkBackground,
    surface: DsColors.darkCard,
    onSurface: DsColors.white,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: DsColors.primary,
      brightness: brightness,
      primary: DsColors.primary,
      secondary: DsColors.orange,
      surface: surface,
      onSurface: onSurface,
      error: DsColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: DsTypography.fontFamily,
      package: DsTypography.package,
      primaryColor: DsColors.primary,
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsDimension.radiusMd),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: DsTypography.h2.copyWith(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: DsColors.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStatePropertyAll(
          DsTypography.captionBold.copyWith(color: onSurface),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DsDimension.radiusLg),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DsColors.primary,
        contentTextStyle: DsTypography.captionBold.copyWith(
          color: DsColors.white,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DsColors.primary,
        foregroundColor: DsColors.white,
      ),
      highlightColor: Colors.transparent,
    );
  }
}
