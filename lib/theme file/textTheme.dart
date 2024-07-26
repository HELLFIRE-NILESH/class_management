import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Texttheme {
  Texttheme._();
  static TextTheme lighttext = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: GoogleFonts.satisfy().fontFamily,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontSize: 26,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: GoogleFonts.satisfy().fontFamily,
      fontWeight: FontWeight.bold,

      fontSize: 24,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: GoogleFonts.satisfy().fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
    displayLarge: TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontSize: 26,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
  );

  static TextTheme darktext = TextTheme(
    bodyLarge: TextStyle(
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,

      fontSize: 24,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontSize: 20,
      color: Colors.white,
    ),
    displayLarge: TextStyle(
      fontFamily:GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontSize: 26,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontSize: 24,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      letterSpacing: 1,
      fontSize: 18,
      color: Colors.white,
    ),
  );
}


