// lib/screens/home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// The main home page of ShopEasy.
// Composed of modular sections:
//   1. AppBar (title + search + cart)
//   2. Search bar
//   3. Banner carousel
//   4. Categories horizontal scroll
//   5. Products grid (with shimmer loading)
//
// Uses a single CustomScrollView with slivers for smooth, unified scrolling
// across all sections — a common pattern in production Flutter apps.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../services/mock_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/cart_badge_icon.dart';
import '../widgets/category_row.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/shimmer_product_grid.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Load mock data (simulates API call) when the screen first mounts
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadProducts();
    });
  }

  // Navigate to product detail with Hero transition
  void _openProductDetail(Product product) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            ProductDetailScreen(product: product),
        transitionsBuilder: (_, animation, __, child) {
          // Fade + slide up transition
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: AppConstants.animNormal,
      ),
    );
  }

  // Navigate to cart screen
  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = MockDataService.getBanners();
    final categories = MockDataService.getCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── 1. Sticky app bar ──────────────────────────────────────────
          _HomeAppBar(onCartTap: _openCart),

          // ── 2. Main content (search + banners + categories + grid) ─────
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppConstants.spaceM),

                // ── Search bar ─────────────────────────────────────────
                _SearchBar(),

                const SizedBox(height: AppConstants.spaceM),

                // ── Banner carousel ────────────────────────────────────
                BannerCarousel(banners: banners),

                const SizedBox(height: AppConstants.spaceXL),

                // ── Categories ─────────────────────────────────────────
                SectionHeader(
                  title: 'Categories',
                  actionLabel: 'See all',
                  onActionTap: () {},
                ),
                const SizedBox(height: AppConstants.spaceM),
                CategoryRow(categories: categories),

                const SizedBox(height: AppConstants.spaceXL),

                // ── Products header ────────────────────────────────────
                Consumer<ProductsProvider>(
                  builder: (context, productsProvider, _) {
                    final categoryName = categories
                        .firstWhere(
                          (c) =>
                              c.id == productsProvider.selectedCategoryId,
                          orElse: () => categories.first,
                        )
                        .name;

                    return SectionHeader(
                      title: productsProvider.selectedCategoryId == 'all'
                          ? 'All Products'
                          : categoryName,
                      actionLabel: 'See all',
                      onActionTap: () {},
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spaceM),
              ]),
            ),
          ),

          // ── 3. Product grid ────────────────────────────────────────────
          _ProductGridSliver(onProductTap: _openProductDetail),

          // Bottom padding
          const SliverPadding(
            padding: EdgeInsets.only(bottom: AppConstants.spaceXXL),
          ),
        ],
      ),
    );
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget {
  final VoidCallback onCartTap;

  const _HomeAppBar({required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,    // Reveals on scroll-up
      snap: true,        // Snaps fully open/closed
      pinned: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: AppConstants.spaceM,
      title: Row(
        children: [
          // App logo emoji
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusS),
            ),
            child: const Center(
              child: Text('🛍️', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: AppConstants.spaceXS),
          // App name
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Shop',
                  style: AppTextStyles.appBarTitle,
                ),
                TextSpan(
                  text: 'Easy',
                  style: AppTextStyles.appBarTitle.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Notification icon (placeholder)
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textPrimary,
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        // Cart icon with badge
        CartBadgeIcon(onTap: onCartTap),
        const SizedBox(width: AppConstants.spaceXXS),
      ],
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
      child: GestureDetector(
        // Tap opens a search page (placeholder — can be wired to SearchDelegate)
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Search coming soon!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  color: AppColors.textSecondary, size: 22),
              const SizedBox(width: AppConstants.spaceXS),
              Text(
                'Search fruits, vegetables, snacks…',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              Container(
                width: 1,
                height: 24,
                color: AppColors.border,
              ),
              const SizedBox(width: AppConstants.spaceXS),
              const Icon(Icons.tune_rounded,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product grid as a Sliver ──────────────────────────────────────────────────
class _ProductGridSliver extends StatelessWidget {
  final void Function(Product) onProductTap;

  const _ProductGridSliver({required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = screenWidth >= AppConstants.tabletBreakpoint
        ? AppConstants.gridColumnsTablet
        : AppConstants.gridColumnsMobile;

    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        // ── Loading state: shimmer ─────────────────────────────────────
        if (provider.isLoading) {
          return SliverToBoxAdapter(
            child: ShimmerProductGrid(itemCount: columns * 3),
          );
        }

        // ── Error state ───────────────────────────────────────────────
        if (provider.errorMessage != null) {
          return SliverToBoxAdapter(
            child: _ErrorView(
              message: provider.errorMessage!,
              onRetry: () => provider.loadProducts(),
            ),
          );
        }

        // ── Empty filtered state ──────────────────────────────────────
        final products = provider.filteredProducts;
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: _EmptyCategory(),
          );
        }

        // ── Products grid ─────────────────────────────────────────────
        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceM,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: AppConstants.gridAspectRatio,
              crossAxisSpacing: AppConstants.gridSpacing,
              mainAxisSpacing: AppConstants.gridSpacing,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                );
              },
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceXXL),
      child: Center(
        child: Column(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppConstants.spaceM),
            Text(message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: AppConstants.spaceM),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty category view ───────────────────────────────────────────────────────
class _EmptyCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceXXL),
      child: Center(
        child: Column(
          children: [
            const Text('📦', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AppConstants.spaceM),
            Text('No products here yet',
                style: AppTextStyles.headingSmall),
            const SizedBox(height: AppConstants.spaceXS),
            Text(
              'Check back soon or try another category.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
