import 'package:flutter/material.dart';

/// Design system border radius tokens
class Radii {
  // None
  static const BorderRadius none = BorderRadius.zero;

  // Extra Small
  static const BorderRadius xxs = BorderRadius.all(Radius.circular(2));
  static const BorderRadius xs = BorderRadius.all(Radius.circular(4));

  // Small
  static const BorderRadius s = BorderRadius.all(Radius.circular(8));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));

  // Medium
  static const BorderRadius m = BorderRadius.all(Radius.circular(16));
  static const BorderRadius md = BorderRadius.all(Radius.circular(20));

  // Large
  static const BorderRadius l = BorderRadius.all(Radius.circular(24));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(28));

  // Pill/Full
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius circle = BorderRadius.all(Radius.circular(1000));

  // Custom Shapes
  static const BorderRadius topOnlyM = BorderRadius.vertical(
    top: Radius.circular(16),
  );
  static const BorderRadius bottomOnlyM = BorderRadius.vertical(
    bottom: Radius.circular(16),
  );
}