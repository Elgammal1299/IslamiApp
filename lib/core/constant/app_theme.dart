import 'package:flutter/material.dart';
import 'package:islami_app/core/constant/app_color.dart';

class AppTheme {
  AppTheme._(); // Private constructor

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    cardColor: AppColors.cardBackground,
    dividerColor: AppColors.divider,
    fontFamily: 'Cairo',
    secondaryHeaderColor: AppColors.secondary,
    hintColor: AppColors.white,
    canvasColor: AppColors.primary2,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.primary),
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.secondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 18),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 16),
      bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.accent),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.cardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    cardColor: AppColors.darkCardBackground,
    dividerColor: AppColors.darkDivider,
    fontFamily: 'Cairo',

    secondaryHeaderColor: AppColors.secondary,
    hintColor: AppColors.black,
    canvasColor: AppColors.primary2,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.primary),
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.accent),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.accent,
      surface: AppColors.darkCardBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
    ),
  );
}
