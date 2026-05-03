import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SkyPass design tokens — deep slate + crisp blue, airy surfaces.
class Styles {
  static const Color primarycolor = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondaryColor = Color(0xFF0D9488);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color textcolor = Color(0xFF0F172A);
  static const Color mutedTextColor = Color(0xFF64748B);
  static const Color bgcolor = Color(0xFFEEF2F9);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color lineColor = Color(0xFFE2E8F0);
  static const Color ticketBlue = Color(0xFF1E3A8A);
  static const Color orangecolor = Color(0xFFEA580C);
  static const Color kakicolor = Color(0xFFFFE7C2);
  static const Color ticketTabColor = Color(0xFFE8EEF9);
  static const Color planeColor = Color(0xFF93C5FD);
  static const Color findTicketColor = primarycolor;
  static const Color circleColor = secondaryColor;
  static const Color ticketColor = Colors.white;

  static const double pagePadding = 20;
  static const double radius = 22;
  static const double smallRadius = 14;

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E3A8A),
      Color(0xFF2563EB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ticketHeroGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ticketLightGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 32,
          offset: const Offset(0, 14),
        ),
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardLift => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static TextStyle get textStyle => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        color: textcolor,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineStyle1 => GoogleFonts.plusJakartaSans(
        fontSize: 30,
        color: textcolor,
        fontWeight: FontWeight.w800,
        height: 1.12,
        letterSpacing: -0.8,
      );

  static TextStyle get headlineStyle2 => GoogleFonts.plusJakartaSans(
        fontSize: 21,
        color: textcolor,
        fontWeight: FontWeight.w800,
        height: 1.22,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineStyle3 => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        color: textcolor,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineStyle4 => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: mutedTextColor,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.1,
      );
}
