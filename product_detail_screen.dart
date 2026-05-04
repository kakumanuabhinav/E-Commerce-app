// lib/screens/product_detail_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Product detail page — navigated to via Hero transition from the product card.
// Shows full product info, reviews, and a persistent "Add to Cart" bottom bar.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing header with product image ───────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.textPrimary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              // Wishlist toggle in the detail header
              Consumer<WishlistProvider>(
                builder: (context, wishlist, _) {
                  final isWishlisted = wishlist.isWishlisted(product.id);
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isWishlisted
                            ? AppColors.wishlistActive
                            : AppColors.textSecondary,
                      ),
                      onPressed: () => wishlist.toggleWishlist(product),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_image_${product.id}', // Matches card's Hero tag
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Product detail body ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusXL),
                ),
              ),
              padding: const EdgeInsets.all(AppConstants.spaceXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category chip ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceS,
                      vertical: AppConstants.spaceXXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceS),

                  // ── Product name ─────────────────────────────────────
                  Text(product.name, style: AppTextStyles.headingLarge),
                  const SizedBox(height: AppConstants.spaceXS),

                  // ── Rating row ───────────────────────────────────────
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final filled = i < product.rating.floor();
                        final half = !filled &&
                            i < product.rating &&
                            product.rating - i >= 0.5;
                        return Icon(
                          filled
                              ? Icons.star_rounded
                              : half
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded,
                          color: const Color(0xFFF39C12),
                          size: 18,
                        );
                      }),
                      const SizedBox(width: AppConstants.spaceXS),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceM),

                  // ── Price section ────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: AppTextStyles.priceLarge,
                      ),
                      const SizedBox(width: AppConstants.spaceXS),
                      if (product.hasDiscount) ...[
                        Text(
                          '₹${product.originalPrice!.toStringAsFixed(0)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textHint,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spaceXS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            '${product.discountPercent}% off',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        product.unit,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.spaceXL),
                  const Divider(),
                  const SizedBox(height: AppConstants.spaceM),

                  // ── Description ──────────────────────────────────────
                  Text('About this product', style: AppTextStyles.headingSmall),
                  const SizedBox(height: AppConstants.spaceS),
                  Text(
                    product.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spaceXL),

                  // ── Info tiles ───────────────────────────────────────
                  _InfoTilesRow(),

                  const SizedBox(height: 100), // Space for the bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Persistent bottom bar: Add to Cart ────────────────────────────
      bottomNavigationBar: _AddToCartBar(product: product),
    );
  }
}

// ── Info tiles (freshness, delivery, organic) ─────────────────────────────────
class _InfoTilesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoTile(
          icon: Icons.verified_rounded,
          label: 'Certified\nOrganic',
          color: AppColors.primary,
        ),
        const SizedBox(width: AppConstants.spaceS),
        _InfoTile(
          icon: Icons.local_shipping_rounded,
          label: 'Same Day\nDelivery',
          color: AppColors.accent,
        ),
        const SizedBox(width: AppConstants.spaceS),
        _InfoTile(
          icon: Icons.cached_rounded,
          label: 'Easy\nReturns',
          color: const Color(0xFF3498DB),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spaceS,
          horizontal: AppConstants.spaceXS,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Add to Cart bar ────────────────────────────────────────────────────
class _AddToCartBar extends StatelessWidget {
  final Product product;
  const _AddToCartBar({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.quantityOf(product.id);
    final inCart = quantity > 0;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceM,
          vertical: AppConstants.spaceS,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price column
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: AppTextStyles.bodySmall),
                Text(
                  '₹${(product.price * (inCart ? quantity : 1)).toStringAsFixed(0)}',
                  style: AppTextStyles.priceLarge,
                ),
              ],
            ),
            const SizedBox(width: AppConstants.spaceM),

            // Cart button
            Expanded(
              child: inCart
                  ? Row(
                      children: [
                        // Decrease
                        _BarButton(
                          icon: Icons.remove_rounded,
                          onTap: () =>
                              cart.decreaseQuantity(product.id),
                          isOutlined: true,
                        ),
                        const SizedBox(width: AppConstants.spaceS),
                        // Quantity display
                        Expanded(
                          child: Center(
                            child: Text(
                              '$quantity in cart',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spaceS),
                        // Increase
                        _BarButton(
                          icon: Icons.add_rounded,
                          onTap: () =>
                              cart.increaseQuantity(product.id),
                        ),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: () => cart.addToCart(product),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spaceS + 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusM),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isOutlined;

  const _BarButton({
    required this.icon,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.primary,
          border: isOutlined
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Icon(
          icon,
          color: isOutlined ? AppColors.primary : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
