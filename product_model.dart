// lib/models/product_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Immutable data model representing a single product.
// Uses Dart's named constructor pattern for JSON deserialization.
// ─────────────────────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice; // For showing "was" price / discount
  final String imageUrl;       // Network URL or local asset path
  final String category;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String unit;           // e.g. "per kg", "per pack", "each"

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.unit,
  });

  // ── JSON deserialization ──────────────────────────────────────────────────
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isAvailable: json['isAvailable'] as bool,
      unit: json['unit'] as String,
    );
  }

  // ── JSON serialization ────────────────────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
      'unit': unit,
    };
  }

  // ── Computed properties ───────────────────────────────────────────────────

  /// Returns true if this product has a discounted price.
  bool get hasDiscount =>
      originalPrice != null && originalPrice! > price;

  /// Returns discount percentage (0–100). Returns 0 if no discount.
  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  // ── Value equality (useful for Provider comparisons) ──────────────────────
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
