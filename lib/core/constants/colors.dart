import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3A7BD5);
  static const Color secondary = Color(0xFF00D2FF);
  static const Color danger = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    colorScheme:
        const ColorScheme.light(primary: primary, secondary: secondary),
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(primary: primary, secondary: secondary),
    scaffoldBackgroundColor: Colors.grey[900],
  );
}
