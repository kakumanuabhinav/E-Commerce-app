// lib/providers/products_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
// Manages the products list state:
//   • Simulates async loading (shimmer effect)
//   • Tracks selected category filter
//   • Exposes filtered product list to the UI
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';

class ProductsProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────────────────
  List<Product> _allProducts = [];
  bool _isLoading = false;
  String _selectedCategoryId = 'all';
  String? _errorMessage;

  // ── Public read-only getters ───────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String get selectedCategoryId => _selectedCategoryId;
  String? get errorMessage => _errorMessage;

  /// Products filtered by the currently selected category.
  List<Product> get filteredProducts {
    if (_selectedCategoryId == 'all') return List.unmodifiable(_allProducts);
    return List.unmodifiable(
      _allProducts.where((p) => p.category == _selectedCategoryId).toList(),
    );
  }

  /// All products regardless of category filter.
  List<Product> get allProducts => List.unmodifiable(_allProducts);

  // ── Initialization ────────────────────────────────────────────────────────

  /// Call this once when the app starts (or when Home screen mounts).
  Future<void> loadProducts() async {
    if (_isLoading) return; // Prevent duplicate loads

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network latency to show shimmer loading effect
      await Future.delayed(const Duration(milliseconds: 1200));

      _allProducts = MockDataService.getProducts();
      debugPrint('📦 ProductsProvider: loaded ${_allProducts.length} products');
    } catch (e) {
      _errorMessage = 'Failed to load products. Please try again.';
      debugPrint('❌ ProductsProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Category filter ───────────────────────────────────────────────────────

  /// Switches the active category filter and notifies listeners.
  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return; // No-op if already selected
    _selectedCategoryId = categoryId;
    notifyListeners();
    debugPrint('📂 ProductsProvider: category changed to "$categoryId"');
  }

  // ── Search ────────────────────────────────────────────────────────────────
  // (Placeholder — can be wired to a real search bar later)
  List<Product> searchProducts(String query) {
    if (query.trim().isEmpty) return filteredProducts;
    final q = query.toLowerCase();
    return _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }
}
