import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C63FF);      // purple
  static const Color primaryDark = Color(0xFF4B44CC);  // dark purple

  // Background
  static const Color background = Color(0xFFF8F9FA);   // light grey
  static const Color surface = Color(0xFFFFFFFF);      // white

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);  // dark
  static const Color textSecondary = Color(0xFF6C757D); // grey

  // Status
  static const Color success = Color(0xFF28A745);      // green
  static const Color error = Color(0xFFDC3545);        // red
  static const Color warning = Color(0xFFFFC107);      // yellow

  // Accent
  static const Color accent = Color(0xFF00BCD4);       // cyan
}

class AppTypography {
  // Headings
  static TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  // Button
  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
      );
}