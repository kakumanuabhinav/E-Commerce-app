// lib/utils/app_colors.dart
// ─────────────────────────────────────────────────────────────────────────────
// Centralised color palette for ShopEasy.
// All colors are defined here so changing the theme only requires
// touching this one file.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // ── Primary brand colors ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF2ECC71);       // Fresh green
  static const Color primaryDark = Color(0xFF27AE60);   // Darker green for pressed states
  static const Color primaryLight = Color(0xFFD5F5E3);  // Soft green tint for backgrounds

  // ── Accent / highlight ────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFF6B35);        // Warm coral-orange
  static const Color accentLight = Color(0xFFFFE8DF);   // Soft accent tint

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAF9);    // Off-white canvas
  static const Color surface = Color(0xFFFFFFFF);       // Pure white cards
  static const Color surfaceVariant = Color(0xFFF0F4F2); // Slightly tinted surface

  // ── Text colors ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A2E1F);   // Near-black with green tint
  static const Color textSecondary = Color(0xFF5D7A66); // Muted green-grey
  static const Color textHint = Color(0xFFA8BEB0);      // Placeholder / disabled

  // ── Semantic colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color wishlistActive = Color(0xFFE74C3C);   // Red heart
  static const Color wishlistInactive = Color(0xFFCCCCCC); // Grey heart

  // ── Shadows & borders ─────────────────────────────────────────────────────
  static const Color shadow = Color(0x14000000); // 8% opacity black
  static const Color border = Color(0xFFE8F0EB);

  // ── Gradient ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF1A2E1F), Color(0x001A2E1F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
