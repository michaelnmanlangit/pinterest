import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && 
           MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // Mobile
    } else if (width < 900) {
      return 3; // Tablet
    } else if (width < 1200) {
      return 4; // Small desktop
    } else {
      return 5; // Large desktop
    }
  }

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 8.0;
    } else if (width < 1200) {
      return 16.0;
    } else {
      return 24.0;
    }
  }

  static double getGridSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 8.0;
    } else {
      return 12.0;
    }
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (width < 1200) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return EdgeInsets.symmetric(horizontal: width * 0.1);
    }
  }
}
