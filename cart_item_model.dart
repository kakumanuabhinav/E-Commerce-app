// lib/models/cart_item_model.dart
// ─────────────────────────────────────────────────────────────────────────────
// Represents one line-item inside the cart.
// Wraps a Product with a mutable quantity.
// ─────────────────────────────────────────────────────────────────────────────

import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // ── Computed properties ───────────────────────────────────────────────────

  /// Total price for this line item (price × quantity).
  double get totalPrice => product.price * quantity;

  // ── Equality ──────────────────────────────────────────────────────────────
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;

  @override
  String toString() =>
      'CartItem(product: ${product.name}, qty: $quantity, total: $totalPrice)';
}
