import 'package:flutter/material.dart';

class FitStartColors {
  static const Color green = Color(0xFFBFFF00);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFF4A4A4A);
  static const Color blackOverlay = Color(0x80000000);
  
  // Gradient colors for animations
  static const Color greenLight = Color(0xFFD4FF33);
  static const Color greenDark = Color(0xFF9AE600);
  
  // Opacity variants
  static Color greenWithOpacity(double opacity) => green.withAlpha((opacity * 255).toInt());
  static Color whiteWithOpacity(double opacity) => white.withAlpha((opacity * 255).toInt());
}