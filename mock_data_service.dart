// lib/services/mock_data_service.dart
// ─────────────────────────────────────────────────────────────────────────────
// Provides static mock data that simulates what a real API would return.
// In production, replace these lists with HTTP calls to your backend.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/banner_model.dart';

class MockDataService {
  MockDataService._(); // Static-only class

  // ── Promotional banners ───────────────────────────────────────────────────
  static List<BannerModel> getBanners() {
    return const [
      BannerModel(
        id: 'b1',
        title: 'Fresh Fruits\nDelivered Fast',
        subtitle: 'Farm to table in under 2 hours',
        tag: '🌿 Fresh Picks',
        backgroundColor: Color(0xFF1B5E20),
        textColor: Colors.white,
        emoji: '🍓',
        actionLabel: 'Shop Now',
      ),
      BannerModel(
        id: 'b2',
        title: 'Up to 40% Off\nOrganic Veggies',
        subtitle: 'Limited time — today only',
        tag: '🔥 Hot Deal',
        backgroundColor: Color(0xFFE65100),
        textColor: Colors.white,
        emoji: '🥦',
        actionLabel: 'Grab Deal',
      ),
      BannerModel(
        id: 'b3',
        title: 'Snack Smart,\nLive Better',
        subtitle: 'Healthy snacks, happy you',
        tag: '⭐ Top Rated',
        backgroundColor: Color(0xFF4A148C),
        textColor: Colors.white,
        emoji: '🥜',
        actionLabel: 'Explore',
      ),
      BannerModel(
        id: 'b4',
        title: 'Free Delivery\nThis Weekend',
        subtitle: 'On all orders above ₹299',
        tag: '🚚 Free Ship',
        backgroundColor: Color(0xFF006064),
        textColor: Colors.white,
        emoji: '🛒',
        actionLabel: 'Order Now',
      ),
      BannerModel(
        id: 'b5',
        title: 'Premium Cold\nPresse Juices',
        subtitle: 'No added sugar, 100% natural',
        tag: '🥤 Beverages',
        backgroundColor: Color(0xFF1565C0),
        textColor: Colors.white,
        emoji: '🍊',
        actionLabel: 'Try Now',
      ),
    ];
  }

  // ── Product categories ────────────────────────────────────────────────────
  static List<CategoryModel> getCategories() {
    return const [
      CategoryModel(
        id: 'all',
        name: 'All',
        icon: Icons.grid_view_rounded,
        color: Color(0xFF2ECC71),
      ),
      CategoryModel(
        id: 'fruits',
        name: 'Fruits',
        icon: Icons.apple_rounded,
        color: Color(0xFFE74C3C),
      ),
      CategoryModel(
        id: 'vegetables',
        name: 'Vegetables',
        icon: Icons.eco_rounded,
        color: Color(0xFF27AE60),
      ),
      CategoryModel(
        id: 'snacks',
        name: 'Snacks',
        icon: Icons.cookie_rounded,
        color: Color(0xFFF39C12),
      ),
      CategoryModel(
        id: 'beverages',
        name: 'Beverages',
        icon: Icons.local_drink_rounded,
        color: Color(0xFF3498DB),
      ),
      CategoryModel(
        id: 'dairy',
        name: 'Dairy',
        icon: Icons.set_meal_rounded,
        color: Color(0xFF9B59B6),
      ),
      CategoryModel(
        id: 'bakery',
        name: 'Bakery',
        icon: Icons.bakery_dining_rounded,
        color: Color(0xFFE67E22),
      ),
    ];
  }

  // ── Products ──────────────────────────────────────────────────────────────
  static List<Product> getProducts() {
    return const [
      // ── Fruits ─────────────────────────────────────────────────────────
      Product(
        id: 'p1',
        name: 'Fresh Strawberries',
        description:
            'Hand-picked sweet strawberries from our partner farms. Rich in antioxidants and vitamin C. Perfect for smoothies, desserts or just snacking.',
        price: 149,
        originalPrice: 199,
        imageUrl: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
        category: 'fruits',
        rating: 4.8,
        reviewCount: 234,
        isAvailable: true,
        unit: 'per 500g',
      ),
      Product(
        id: 'p2',
        name: 'Alphonso Mangoes',
        description:
            'Premium Alphonso mangoes directly sourced from Ratnagiri, Maharashtra. Sweet, aromatic, and absolutely delicious. GI-tagged certified.',
        price: 299,
        originalPrice: 399,
        imageUrl: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400',
        category: 'fruits',
        rating: 4.9,
        reviewCount: 512,
        isAvailable: true,
        unit: 'per dozen',
      ),
      Product(
        id: 'p3',
        name: 'Organic Bananas',
        description:
            'Fresh organic bananas grown without pesticides. Great source of potassium and natural energy. Ripe and ready to eat.',
        price: 59,
        imageUrl: 'https://images.unsplash.com/photo-1543218024-57a70143c369?w=400',
        category: 'fruits',
        rating: 4.6,
        reviewCount: 178,
        isAvailable: true,
        unit: 'per dozen',
      ),
      Product(
        id: 'p4',
        name: 'Red Apples',
        description:
            'Crisp and juicy Himachal Pradesh apples. High in fibre and naturally sweet. Keeps doctors away (literally).',
        price: 129,
        originalPrice: 160,
        imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
        category: 'fruits',
        rating: 4.7,
        reviewCount: 310,
        isAvailable: true,
        unit: 'per kg',
      ),

      // ── Vegetables ─────────────────────────────────────────────────────
      Product(
        id: 'p5',
        name: 'Broccoli Crown',
        description:
            'Bright green broccoli crowns, packed with vitamins K and C. Freshly harvested and chilled for maximum nutrition.',
        price: 89,
        imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400',
        category: 'vegetables',
        rating: 4.5,
        reviewCount: 145,
        isAvailable: true,
        unit: 'each',
      ),
      Product(
        id: 'p6',
        name: 'Cherry Tomatoes',
        description:
            'Sweet, plump cherry tomatoes great for salads and pasta. No artificial ripening — sun-grown and naturally red.',
        price: 79,
        originalPrice: 99,
        imageUrl: 'https://images.unsplash.com/photo-1546094096-0df4bcabd337?w=400',
        category: 'vegetables',
        rating: 4.6,
        reviewCount: 203,
        isAvailable: true,
        unit: 'per 250g',
      ),
      Product(
        id: 'p7',
        name: 'Baby Spinach',
        description:
            'Tender young spinach leaves, washed and ready to eat. Excellent source of iron, magnesium and folate.',
        price: 69,
        imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
        category: 'vegetables',
        rating: 4.4,
        reviewCount: 98,
        isAvailable: true,
        unit: 'per 200g',
      ),
      Product(
        id: 'p8',
        name: 'Bell Pepper Mix',
        description:
            'Colourful trio of red, yellow and green bell peppers. Crisp texture, sweet flavour, zero fat. Add colour to your cooking.',
        price: 119,
        originalPrice: 149,
        imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
        category: 'vegetables',
        rating: 4.7,
        reviewCount: 167,
        isAvailable: true,
        unit: 'pack of 3',
      ),

      // ── Snacks ─────────────────────────────────────────────────────────
      Product(
        id: 'p9',
        name: 'Mixed Nuts Jar',
        description:
            'Premium blend of almonds, cashews, walnuts and pistachios. Dry-roasted with a pinch of Himalayan salt. No oils added.',
        price: 349,
        originalPrice: 449,
        imageUrl: 'https://images.unsplash.com/photo-1574184864703-3487b13f0edd?w=400',
        category: 'snacks',
        rating: 4.8,
        reviewCount: 422,
        isAvailable: true,
        unit: 'per 500g jar',
      ),
      Product(
        id: 'p10',
        name: 'Multigrain Crackers',
        description:
            'Crispy crackers made with oats, wheat and seeds. No maida, no trans fat. Perfect with hummus or cheese.',
        price: 149,
        imageUrl: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400',
        category: 'snacks',
        rating: 4.3,
        reviewCount: 189,
        isAvailable: true,
        unit: 'per 200g pack',
      ),

      // ── Beverages ──────────────────────────────────────────────────────
      Product(
        id: 'p11',
        name: 'Cold Brew Coffee',
        description:
            'Smooth, low-acidity cold brew made with single-origin Arabica beans. 12-hour steeped, ready to drink. No sugar added.',
        price: 199,
        originalPrice: 249,
        imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
        category: 'beverages',
        rating: 4.9,
        reviewCount: 634,
        isAvailable: true,
        unit: 'per 250ml bottle',
      ),
      Product(
        id: 'p12',
        name: 'Green Detox Juice',
        description:
            'Cold-pressed blend of spinach, cucumber, celery, lemon and ginger. Energize your mornings the healthy way.',
        price: 179,
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
        category: 'beverages',
        rating: 4.6,
        reviewCount: 287,
        isAvailable: true,
        unit: 'per 300ml bottle',
      ),
    ];
  }

  /// Returns products filtered by category id.
  /// If [categoryId] is 'all' or null, returns everything.
  static List<Product> getProductsByCategory(String? categoryId) {
    final all = getProducts();
    if (categoryId == null || categoryId == 'all') return all;
    return all.where((p) => p.category == categoryId).toList();
  }
}
