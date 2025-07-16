import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    primaryColorDark: AppColors.black,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.secondary,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      trackHeight: 4,
      // ممكن تضيف كمان لو عايز:
      // valueIndicatorColor: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: AppColors.black),

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
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 18.sp),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
      bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),

      titleLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
      titleMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      titleSmall: TextStyle(
        color: AppColors.darkDivider,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
      labelLarge: TextStyle(
        fontFamily: "arsura",
        fontSize: 30.sp,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.accent),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.black,
      selectedIconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
      unselectedIconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
      selectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

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
    primaryColorDark: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondary,
      floatingLabelStyle: TextStyle(color: AppColors.black),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.primary),
      hintStyle: const TextStyle(color: AppColors.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.white),
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

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary, fontSize: 16.sp),
      bodyMedium: TextStyle(
        color: AppColors.darkTextSecondary,
        fontSize: 14.sp,
      ),
      bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
      titleMedium: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
      labelLarge: TextStyle(
        fontFamily: "arsura",
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
        color: AppColors.white,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.accent),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.black,
      selectedIconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
      unselectedIconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
      selectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

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
