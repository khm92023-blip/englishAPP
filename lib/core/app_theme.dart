import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ثيم موحّد للتطبيق بألوان مرحة ومناسبة للأطفال
class AppTheme {
  AppTheme._();

  // ألوان أساسية مرحة
  static const Color primary = Color(0xFF6C5CE7); // بنفسجي مرح
  static const Color secondary = Color(0xFFFFA502); // برتقالي دافئ
  static const Color success = Color(0xFF2ED573);
  static const Color error = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8F7FF);

  // ألوان مميزة لكل صف دراسي (تُستخدم في بطاقات اختيار الصف)
  static const List<Color> gradeColors = [
    Color(0xFFFF6B6B), // الصف الأول - أحمر مرجاني
    Color(0xFF4ECDC4), // الصف الثاني - فيروزي
    Color(0xFFFFA502), // الصف الثالث - برتقالي
    Color(0xFF6C5CE7), // الصف الرابع - بنفسجي
  ];

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.baloo2TextTheme();
    final arabicTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        error: error,
        brightness: Brightness.light,
      ),
      // نستخدم خط Cairo للنصوص العربية كأساس، وهو يدعم الأرقام والإنجليزية أيضًا بشكل جيد
      textTheme: arabicTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: const Color(0xFF2D3436),
          fontWeight: FontWeight.bold,
        ),
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2D3436),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
