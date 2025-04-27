import 'package:flutter/material.dart';
import 'font_weights.dart';

/// Design system typography tokens (Material 3 compliant)
class TextStyles {
  // Display Styles (Large headline text)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeights.regular,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeights.regular,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeights.regular,
    height: 1.22,
  );

  // Headline Styles (Section headers)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeights.regular,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeights.regular,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeights.regular,
    height: 1.33,
  );

  // Title Styles (Smaller headers)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeights.medium,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body Styles (Paragraph text)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeights.regular,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeights.regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeights.regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles (Buttons, tags)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // App-specific text styles
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeights.semiBold,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle textLink = TextStyle(
    fontSize: 16,
    fontWeight: FontWeights.medium,
    letterSpacing: 0.5,
    height: 1.5,
    decoration: TextDecoration.underline,
  );
} 