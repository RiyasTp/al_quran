import 'package:flutter/material.dart';

/// Design system shadow tokens (Material 3 elevation levels)
class Shadows {
  // Level 0 (No shadow)
  static const BoxShadow none = BoxShadow(color: Colors.transparent);

  // Level 1 (Buttons, Cards)
  static const BoxShadow xxs = BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  // Level 2 (FAB, Dialogs)
  static const BoxShadow xs = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 2),
    blurRadius: 6,
    spreadRadius: -1,
  );

  // Level 3 (Navigation)
  static const List<BoxShadow> s = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 3),
      blurRadius: 12,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -6,
    ),
  ];

  // Level 4 (Modal Sheets)
  static const List<BoxShadow> m = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -12,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -12,
    ),
  ];

  // Level 5 (Toasts, Popovers)
  static const List<BoxShadow> l = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: -16,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 24),
      blurRadius: 64,
      spreadRadius: -24,
    ),
  ];

  // Glow (Special cases)
  static const BoxShadow glowPrimary = BoxShadow(
    color: Color(0x4D6750A4), // 30% opacity primary color
    blurRadius: 12,
    spreadRadius: 2,
  );
}