import 'package:flutter/material.dart';

const Color primary = Color(0xFF2F6FED);

class Styles {
  static const Color primarycolor = primary;
  static const Color secondaryColor = Color(0xFF14B8A6);
  static const Color accentColor = Color(0xFFFFB545);
  static const Color textcolor = Color(0xFF172033);
  static const Color mutedTextColor = Color(0xFF6B7280);
  static const Color bgcolor = Color(0xFFF6F8FC);
  static const Color surfaceColor = Colors.white;
  static const Color lineColor = Color(0xFFE5EAF3);
  static const Color ticketBlue = Color(0xFF243B6B);
  static const Color orangecolor = Color(0xFFFF7A59);
  static const Color kakicolor = Color(0xFFFFE7C2);
  static const Color ticketTabColor = Color(0xFFEAF0FF);
  static const Color planeColor = Color(0xFF8FB4FF);
  static const Color findTicketColor = Color(0xFF2F6FED);
  static const Color circleColor = Color(0xFF14B8A6);
  static const Color ticketColor = Colors.white;

  static const double pagePadding = 20;
  static const double radius = 22;
  static const double smallRadius = 14;

  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF18345B).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static const TextStyle textStyle = TextStyle(
    fontSize: 16,
    color: textcolor,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle headlineStyle1 = TextStyle(
    fontSize: 30,
    color: textcolor,
    fontWeight: FontWeight.w800,
    height: 1.08,
  );

  static const TextStyle headlineStyle2 = TextStyle(
    fontSize: 21,
    color: textcolor,
    fontWeight: FontWeight.w800,
    height: 1.18,
  );

  static const TextStyle headlineStyle3 = TextStyle(
    fontSize: 17,
    color: textcolor,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle headlineStyle4 = TextStyle(
    fontSize: 14,
    color: mutedTextColor,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
}
