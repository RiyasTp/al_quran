import 'package:flutter/material.dart';

/// Design system font weight tokens
/// (Matches Google Fonts numerical weights)
class FontWeights {
  // Hairline weight (rarely used)
  static const FontWeight hairline = FontWeight.w100;
  
  // Extra light/thin
  static const FontWeight extraLight = FontWeight.w200;
  
  // Light weight
  static const FontWeight light = FontWeight.w300;
  
  // Regular/normal weight
  static const FontWeight regular = FontWeight.w400;
  
  // Medium weight
  static const FontWeight medium = FontWeight.w500;
  
  // Semi-bold weight
  static const FontWeight semiBold = FontWeight.w600;
  
  // Bold weight
  static const FontWeight bold = FontWeight.w700;
  
  // Extra bold weight
  static const FontWeight extraBold = FontWeight.w800;
  
  // Black/heavy weight
  static const FontWeight black = FontWeight.w900;

  // Aliases for Material compatibility
  static const FontWeight normal = regular;
}