// lib/main.dart
// ─────────────────────────────────────────────────────────────────────────────
// Application entry point for ShopEasy.
//
// Responsibilities:
//   • Bootstrap Flutter engine
//   • Register all Provider instances at the root
//   • Apply global theme
//   • Set HomeScreen as the initial route
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() {
  // Ensure Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode (optional — remove to allow landscape)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make the status bar transparent for an edge-to-edge look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ShopEasyApp());
}

/// Root widget — sits above MaterialApp so Providers are available
/// to ALL descendants including Navigator pages.
class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cart state — needed across home, detail, and cart screens
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),

        // Products + category filter state
        ChangeNotifierProvider<ProductsProvider>(
          create: (_) => ProductsProvider(),
        ),

        // Wishlist state
        ChangeNotifierProvider<WishlistProvider>(
          create: (_) => WishlistProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ShopEasy',
        debugShowCheckedModeBanner: false,

        // Apply our custom Material 3 light theme
        theme: AppTheme.lightTheme,

        // Start on the home screen
        home: const HomeScreen(),

        // Route builder for named navigation (extensible)
        routes: {
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
