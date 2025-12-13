import 'package:flutter/material.dart';

class colorsApp {
// ================= PRIMARY COLORS =================
  // Biru Modern - Warna utama aplikasi
  static const Color primary = Color(0xFF4361EE);
  static const Color primaryLight = Color(0xFF4895EF);
  static const Color primaryDark = Color(0xFF3A0CA3);
  static const Color primaryExtraLight = Color(0xFFF0F4FF);

  // ================= SECONDARY COLORS =================
  // Ungu - Warna sekunder
  static const Color secondary = Color(0xFF7209B7);
  static const Color secondaryLight = Color(0xFFB5179E);
  static const Color secondaryExtraLight = Color(0xFFF8F0FF);

  // ================= ACCENT COLORS =================
  // Biru Muda - Warna aksen
  static const Color accent = Color(0xFF4CC9F0);
  static const Color accentLight = Color(0xFF56CFE1);

  // ================= STATUS COLORS =================
  static const Color success = Color(0xFF2ECC71); // Hijau
  static const Color successLight = Color(0xFFD5F4E6);
  static const Color warning = Color(0xFFF39C12); // Oranye
  static const Color warningLight = Color(0xFFFDEDD4);
  static const Color error = Color(0xFFE74C3C); // Merah
  static const Color errorLight = Color(0xFFFADBD8);
  static const Color info = Color(0xFF3498DB); // Biru Info
  static const Color infoLight = Color(0xFFD6EAF8);

  // ================= NEUTRAL COLORS =================
  // Background & Surface
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFFF5F7FB);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF34495E);
  static const Color textTertiary = Color(0xFF7F8C8D);
  static const Color textHint = Color(0xFFBDC3C7);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE8EDF2);
  static const Color borderLight = Color(0xFFF1F3F5);
  static const Color borderDark = Color(0xFFD5DBE1);
  static const Color divider = Color(0xFFECF0F1);

  // Overlay & Shadow
  static const Color overlay = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color shadow = Color.fromRGBO(67, 97, 238, 0.1);

  // ================= STATE COLORS =================
  static const Color active = Color(0xFF2ECC71);
  static const Color inactive = Color(0xFFE74C3C);
  static const Color pending = Color(0xFFF39C12);
  static const Color selected = Color(0xFF4361EE);

  // ================= GRADIENTS =================
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF4361EE), Color(0xFF4895EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static LinearGradient secondaryGradient = const LinearGradient(
    colors: [Color(0xFF7209B7), Color(0xFFB5179E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient = const LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient warningGradient = const LinearGradient(
    colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradient = const LinearGradient(
    colors: [Color(0xFF4CC9F0), Color(0xFF4361EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient untuk card header
  static LinearGradient cardHeaderGradient = const LinearGradient(
    colors: [Color(0xFF4361EE), Color(0xFF3A0CA3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ================= SHADOWS =================
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 15,
      spreadRadius: 0,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 25,
      spreadRadius: 0,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];
}
