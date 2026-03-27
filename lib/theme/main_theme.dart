import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorsScheme = ColorScheme(
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
);

final textThemes = GoogleFonts.acmeTextTheme(
  TextTheme(
    titleLarge: TextStyle(color: Color(0xFF181003), fontSize: 32),
    titleMedium: TextStyle(color: Color(0xFFDD0404), fontSize: 28),
    titleSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 22),

    labelLarge: TextStyle(color: Color(0xFFFFC745), fontSize: 32),
    labelSmall: TextStyle(color: Color(0xFF181003), fontSize: 24),

    bodyMedium: TextStyle(color: Color(0xFFFFC745), fontSize: 28),
    bodySmall: TextStyle(color: Color(0xFFFFC745), fontSize: 24),
  ),
);

final loginContainerDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [colorsScheme.inversePrimary, colorsScheme.secondary],
  ),
);

final pagesDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [colorsScheme.primary, colorsScheme.inversePrimary],
    begin: AlignmentGeometry.centerLeft,
    end: AlignmentGeometry.bottomRight,
  ),
);

final kodishaTheme = ThemeData(
  colorScheme: colorsScheme,
  textTheme: textThemes,
  appBarTheme: AppBarTheme(
    backgroundColor: colorsScheme.inversePrimary,
    titleTextStyle: textThemes.titleLarge,
    actionsPadding: EdgeInsets.all(4),
  ),
  inputDecorationTheme: InputDecorationThemeData(
    contentPadding: EdgeInsets.all(18),
    labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
    floatingLabelStyle: TextStyle(color: Color(0xFFFFFFFF)),
    border: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorsScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
    ),
  ),
);
