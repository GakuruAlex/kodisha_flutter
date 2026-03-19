import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kodishaTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF003332),
    onPrimary: Color(0xFFFFC745),

    secondary: Color(0xFF76C6F5),
    onSecondary: Color(0xFF181003),

    error: Color(0xFFDD0404),
    onError: Color(0xFFFFFFFF),

    surface: Color(0xFF181003),
    onSurface: Color(0xFFFFFFFF),

    tertiary: Color(0xFF4CAF50),
    onTertiary: Color(0xFFFFFFFF),

    outline: Color(0xFF888888),
    shadow: Color(0xFF000000),
  ),
  textTheme: GoogleFonts.acmeTextTheme(
    TextTheme(
      labelLarge: TextStyle(color: Color(0xFFFFC745), fontSize: 48),
      bodyMedium: TextStyle(color: Color(0xFFFFC745), fontSize: 32),
      bodySmall: TextStyle(color: Color(0xFFFFC745), fontSize: 24),
    ),
  ),
);
