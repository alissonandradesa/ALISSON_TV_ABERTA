import 'package:flutter/material.dart';

class AppTheme {
  static Color getPrimaryColor(String gender) {
    return gender == 'menina' ? const Color(0xFFE91E63) : const Color(0xFF2196F3); // Rosa vibrante ou Azul
  }

  static Color getLightBackgroundColor(String gender) {
    return gender == 'menina' ? const Color(0xFFFCE4EC) : const Color(0xFFE3F2FD); // Rosa bem claro ou Azul bem claro
  }

  static Color getCardBackgroundColor(String gender) {
    return gender == 'menina' ? const Color(0xFFFFF0F5) : const Color(0xFFF0F8FF); // Tons pastéis modernos
  }
}