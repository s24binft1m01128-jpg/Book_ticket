import 'package:flutter/material.dart';

class AppLayout {
  static Size getsize(BuildContext context) => MediaQuery.sizeOf(context);

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) {
      return 40;
    }
    if (width >= 600) {
      return 28;
    }
    return 20;
  }

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width > 760 ? 720 : width;
  }
}
