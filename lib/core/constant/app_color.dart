import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor

  /// -------- Base Color --------
  static const Color primary = Color(0xFF2B6777); // الأزرق الإسلامي الرئيسي
  static const Color primary2 = Colors.teal;
  static const Color red = Colors.red;

  /// -------- Supporting Colors --------
  static const Color secondary = Color(
    0xFFC8D8E4,
  ); // أزرق فاتح جدًا ناعم (مساند)
  static const Color accent = Color(0xFFF2BE22); // لون ذهبي دافئ (مكمل راقي)

  /// -------- Backgrounds --------
  static const Color background = Color(
    0xFFF9F9F9,
  ); // رمادي فاتح جدًا (خلفية عامة)
  static const Color cardBackground = Color(0xFFFFFFFF); // أبيض ناصع (للبطاقات)
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  /// -------- Text Colors --------
  static const Color textPrimary = Color(0xFF1E2D2F); // رمادي غامق مائل للأزرق
  static const Color textSecondary = Color(0xFF6B7B7C); // رمادي هادي

  /// -------- Border/Divider --------
  static const Color divider = Color(0xFFE0E0E0); // رمادي فاتح

  /// -------- Status Colors --------
  static const Color success = Color(0xFF4CAF50); // أخضر للإشعارات الإيجابية
  static const Color error = Color(0xFFB00020); // أحمر للأخطاء

  /// -------- Dark Theme Colors --------
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF144552);
  static const Color darkTextPrimary = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkDivider = Color(0xFF2C2C2C);
}
/*
  // Light Theme Colors
  static const Color lightPrimary = primary;
  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightSurface = Colors.white;
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnBackground = Color(0xFF1C1C1C);
  static const Color lightOnSurface = Color(0xFF333333);
  static const Color lightSecondary = Color(
    0xFF52AB98,
  ); // لون مائل للأخضر المتناسق مع الأزرق
  static const Color lightTextPrimary = Color(0xFF1C1C1C);
  static const Color lightTextSecondary = Color(0xFF555555);
  static const Color lightCard = Colors.white;
  static const Color lightIcon = primary;
  // Dark Theme Colors
  static const Color darkPrimary = primary;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnPrimary = Colors.white;
  static const Color darkOnBackground = Colors.white70;
  static const Color darkOnSurface = Colors.white70;
  static const Color darkSecondary = Color(0xFF88CDD2); // لون ثانوي أفتح شوية
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkIcon = Color(0xFF88CDD2);
  // Optional error/success
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
 */