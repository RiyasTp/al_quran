import 'package:flutter/material.dart';

/// Design system spacing tokens (8px baseline grid)
class Spacing {
  // Zero
  static const double zero = 0;

  // XS
  static const double xxs = 2;
  static const double xs = 4;

  // Small
  static const double s = 8;
  static const double sm = 12;

  // Medium
  static const double m = 16;
  static const double md = 24;

  // Large
  static const double l = 32;
  static const double lg = 40;

  // XL
  static const double xl = 48;
  static const double xxl = 64;

  // Edge Insets (Pre-configured padding)
  static const EdgeInsets allXXS = EdgeInsets.all(xxs);
  static const EdgeInsets allXS = EdgeInsets.all(xs);
  static const EdgeInsets allS = EdgeInsets.all(s);
  static const EdgeInsets allM = EdgeInsets.all(m);
  static const EdgeInsets allL = EdgeInsets.all(l);

  // Symmetric
  static const EdgeInsets horizontalS = EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets horizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets verticalS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets verticalM = EdgeInsets.symmetric(vertical: m);

  // Responsive Helpers
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(context).width < 600 ? s : m,
      vertical: MediaQuery.sizeOf(context).height < 800 ? s : m,
    );
  }
}