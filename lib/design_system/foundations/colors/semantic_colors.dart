import 'package:flutter/material.dart';

/// Semantic colors for specific UI states (M3 compliant)
class SemanticColors {
  // Success Colors
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color onSuccessContainer = Color(0xFF2E7D32);

  // Error Colors
  static const Color error = Color(0xFFB00020); // Red 900
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color onErrorContainer = Color(0xFFC62828);

  // Warning Colors
  static const Color warning = Color(0xFFFF9800); // Amber 500
  static const Color onWarning = Color(0xFF000000);
  static const Color warningContainer = Color(0xFFFFECB3);
  static const Color onWarningContainer = Color(0xFFE65100);

  // Info Colors
  static const Color info = Color(0xFF2196F3); // Blue 500
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFBBDEFB);
  static const Color onInfoContainer = Color(0xFF0D47A1);

  // Disabled State
  static const Color disabled = Color(0xFF9E9E9E); // Grey 500
  static const Color onDisabled = Color(0xFF616161); // Grey 700
  static const Color disabledContainer = Color(0xFFEEEEEE); // Grey 200

  // Interactive States (Primary Variants)
  static const Color hover = Color(0xFF5D43A6); // Primary +10% darkness
  static const Color focus = Color(0xFF7C64C3); // Primary +20% lightness
  static const Color pressed = Color(0xFF4F378B); // Primary -20% lightness
  static const Color dragged = Color(0xFF9575CD); // Primary +30% lightness
}


/// Dark theme semantic colors
class DarkSemanticColors {
  // Success Colors
  static const Color success = Color(0xFF81C784); // Green 300
  static const Color onSuccess = Color(0xFF1B5E20);
  static const Color successContainer = Color(0xFF2E7D32);
  static const Color onSuccessContainer = Color(0xFFC8E6C9);

  // Error Colors
  static const Color error = Color(0xFFCF6679); // Red 200
  static const Color onError = Color(0xFFB00020);
  static const Color errorContainer = Color(0xFFC62828);
  static const Color onErrorContainer = Color(0xFFFFCDD2);

  // Warning Colors
  static const Color warning = Color(0xFFFFB74D); // Amber 300
  static const Color onWarning = Color(0xFFE65100);
  static const Color warningContainer = Color(0xFFF57C00);
  static const Color onWarningContainer = Color(0xFFFFECB3);

  // Info Colors
  static const Color info = Color(0xFF64B5F6); // Blue 300
  static const Color onInfo = Color(0xFF0D47A1);
  static const Color infoContainer = Color(0xFF1976D2);
  static const Color onInfoContainer = Color(0xFFBBDEFB);

  // Disabled State
  static const Color disabled = Color(0xFF757575); // Grey 600
  static const Color onDisabled = Color(0xFFBDBDBD); // Grey 400
  static const Color disabledContainer = Color(0xFF424242); // Grey 800
}