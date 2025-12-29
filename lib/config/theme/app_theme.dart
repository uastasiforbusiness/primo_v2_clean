import 'package:flutter/material.dart';

/// AppTheme - Defines the visual theme for PRIMO V2 POS
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color palette
  static const Color _primaryColor = Color(0xFF2196F3); // Blue
  static const Color _secondaryColor = Color(0xFF4CAF50); // Green
  static const Color _errorColor = Color(0xFFF44336); // Red
  static const Color _backgroundColor = Color(0xFFF5F5F5); // Light gray

  /// Light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _secondaryColor,
        error: _errorColor,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),

      // Scaffold background
      scaffoldBackgroundColor: _backgroundColor,
    );
  }

  /// Dark theme for the application (future implementation)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _secondaryColor,
        error: _errorColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
