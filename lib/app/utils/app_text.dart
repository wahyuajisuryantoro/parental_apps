import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyle {
  static final TextStyle heading1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
  );

  static final TextStyle smallHeading1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static final TextStyle heading2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

   static final TextStyle blackHeading2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final TextStyle bodyText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle bodyTextBlack = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final TextStyle bodyTextBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static final TextStyle buttonText = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static final TextStyle captionWhite = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.white,
  );
}
