// lib/providers/cart_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
// Manages the shopping cart state using Flutter's Provider package.
//
// Responsibilities:
//   • Add / remove items
//   • Increase / decrease quantity
//   • Expose computed totals (item count, subtotal, etc.)
//
// All mutations call notifyListeners() so any widget watching this provider
// will rebuild automatically.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // ── Internal cart state ────────────────────────────────────────────────────
  // Map<productId, CartItem> for O(1) lookups.
  final Map<String, CartItem> _items = {};

  // ── Public read-only accessors ────────────────────────────────────────────

  /// All cart items as an unmodifiable list.
  List<CartItem> get items => List.unmodifiable(_items.values);

  /// Total number of *units* in the cart (sum of all quantities).
  int get totalItemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Number of distinct products in the cart.
  int get distinctItemCount => _items.length;

  /// Subtotal before taxes/delivery.
  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Whether the cart is empty.
  bool get isEmpty => _items.isEmpty;

  /// Delivery charge — free above ₹299, else ₹49.
  double get deliveryCharge => subtotal >= 299 ? 0 : 49;

  /// Grand total including delivery.
  double get grandTotal => subtotal + deliveryCharge;

  // ── Cart operations ────────────────────────────────────────────────────────

  /// Returns the quantity of a product currently in the cart.
  /// Returns 0 if the product isn't in the cart.
  int quantityOf(String productId) => _items[productId]?.quantity ?? 0;

  /// Returns true if the product is already in the cart.
  bool contains(String productId) => _items.containsKey(productId);

  /// Adds a product to the cart.
  /// If it's already there, increments its quantity instead.
  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      // Product already exists — just bump the count
      _items[product.id]!.quantity++;
    } else {
      // New product — create a cart item with quantity = 1
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
    debugPrint('🛒 Cart: added "${product.name}" (qty: ${_items[product.id]!.quantity})');
  }

  /// Decreases quantity by 1.
  /// Removes the item entirely when quantity reaches 0.
  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity <= 1) {
      removeFromCart(productId);
    } else {
      _items[productId]!.quantity--;
      notifyListeners();
      debugPrint('🛒 Cart: decreased "${_items[productId]!.product.name}" (qty: ${_items[productId]!.quantity})');
    }
  }

  /// Increases quantity by 1 (alias for addToCart on existing items).
  void increaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    _items[productId]!.quantity++;
    notifyListeners();
  }

  /// Removes a product completely from the cart.
  void removeFromCart(String productId) {
    if (!_items.containsKey(productId)) return;
    final name = _items[productId]!.product.name;
    _items.remove(productId);
    notifyListeners();
    debugPrint('🛒 Cart: removed "$name"');
  }

  /// Empties the cart completely.
  void clearCart() {
    _items.clear();
    notifyListeners();
    debugPrint('🛒 Cart: cleared all items');
  }

  @override
  String toString() =>
      'CartProvider(items: $distinctItemCount, total: ₹$grandTotal)';
}
