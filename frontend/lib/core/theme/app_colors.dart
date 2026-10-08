import 'package:flutter/material.dart';

class AppColors {
  // Brand Orange Accent Colors
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryLight = Color(0xFFFFA040);
  static const Color primaryDark = Color(0xFFE65C00);
  static const Color accentGold = Color(0xFFFFB800);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA040), Color(0xFFFF6600)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF9320), Color(0xFFFF6400)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF222428), Color(0xFF161719)],
  );

  // Dark Scheme (for Splash, Onboarding & Video Reels)
  static const Color darkBackground = Color(0xFF0C0D0E);
  static const Color darkSurface = Color(0xFF16171A);
  static const Color darkCard = Color(0xFF1E2024);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF9E9EA7);

  // Light Scheme (for Dashboard Home Screen as in Reference)
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1A1C1E);
  static const Color lightTextSecondary = Color(0xFF757880);
  static const Color lightCardBorder = Color(0xFFEFEFEF);
  
  // Tag / Chip Colors
  static const Color tagMuscle = Color(0xFF2C2219);
  static const Color tagMuscleText = Color(0xFFFF8E32);
  static const Color tagCardio = Color(0xFFFFF2E5);
  static const Color tagCardioText = Color(0xFFFF7A00);
}
