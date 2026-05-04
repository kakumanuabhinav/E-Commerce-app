// lib/providers/wishlist_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
// BONUS: Manages the wishlist (favourite) toggle state.
// Products can be added/removed from the wishlist independently of the cart.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────────────────
  // Set of product IDs that are in the wishlist.
  final Set<String> _wishlistedIds = {};
  final List<Product> _wishlistProducts = [];

  // ── Public getters ────────────────────────────────────────────────────────
  List<Product> get wishlistProducts => List.unmodifiable(_wishlistProducts);
  int get count => _wishlistedIds.length;

  /// Returns true if the given product is in the wishlist.
  bool isWishlisted(String productId) => _wishlistedIds.contains(productId);

  // ── Toggle ────────────────────────────────────────────────────────────────

  /// Toggles a product in/out of the wishlist.
  /// Returns true if the product was *added*, false if it was *removed*.
  bool toggleWishlist(Product product) {
    final id = product.id;
    if (_wishlistedIds.contains(id)) {
      _wishlistedIds.remove(id);
      _wishlistProducts.removeWhere((p) => p.id == id);
      notifyListeners();
      debugPrint('💔 Wishlist: removed "${product.name}"');
      return false;
    } else {
      _wishlistedIds.add(id);
      _wishlistProducts.add(product);
      notifyListeners();
      debugPrint('❤️  Wishlist: added "${product.name}"');
      return true;
    }
  }
}
