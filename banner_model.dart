// lib/models/banner_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Data model for a promotional banner displayed in the carousel slider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String tag;           // e.g. "Fresh Deals", "Limited Offer"
  final Color backgroundColor;
  final Color textColor;
  final String emoji;          // Emoji used as visual instead of network image
  final String? actionLabel;   // CTA button label

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.backgroundColor,
    required this.textColor,
    required this.emoji,
    this.actionLabel,
  });
}
