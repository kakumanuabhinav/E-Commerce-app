// lib/models/category_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Simple data model representing a product category chip shown in the
// horizontal scroll row on the Home screen.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;   // Material icon representing the category
  final Color color;     // Accent color for the category circle background

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
