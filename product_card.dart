// lib/widgets/product_card.dart
// ─────────────────────────────────────────────────────────────────────────────
// Individual product card displayed inside the GridView.
// Features:
//   • Network image with error fallback
//   • Discount badge
//   • Wishlist (favourite) heart toggle with animation (BONUS)
//   • Quantity stepper when item is already in cart
//   • Hero animation tag on image (for Product Detail transition) (BONUS)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap; // Navigate to detail page

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Product image + badges ─────────────────────────────────
              _ProductImageSection(product: product),

              // ── Product info ───────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spaceS,
                    AppConstants.spaceXS,
                    AppConstants.spaceS,
                    AppConstants.spaceXS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        product.name,
                        style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Unit (e.g. "per kg")
                      Text(
                        product.unit,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      ),

                      const Spacer(),

                      // Price row + Add to Cart
                      _PriceAndCartRow(product: product),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product image section (image + wishlist + discount badge) ─────────────────
class _ProductImageSection extends StatelessWidget {
  final Product product;
  const _ProductImageSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Network image with Hero animation ──────────────────────────
        Hero(
          tag: 'product_image_${product.id}',
          child: Container(
            height: 130,
            width: double.infinity,
            color: AppColors.surfaceVariant,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) {
                // Fallback placeholder when network fails
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 36,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No image',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // ── Discount badge (top-left) ────────────────────────────────
        if (product.hasDiscount)
          Positioned(
            top: AppConstants.spaceXS,
            left: AppConstants.spaceXS,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Text(
                '-${product.discountPercent}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),

        // ── Wishlist toggle button (top-right) ────────────────────────
        Positioned(
          top: AppConstants.spaceXXS,
          right: AppConstants.spaceXXS,
          child: _WishlistButton(product: product),
        ),
      ],
    );
  }
}

// ── Animated wishlist heart button ────────────────────────────────────────────
class _WishlistButton extends StatefulWidget {
  final Product product;
  const _WishlistButton({required this.product});

  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    context.read<WishlistProvider>().toggleWishlist(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final isWishlisted = context
        .watch<WishlistProvider>()
        .isWishlisted(widget.product.id);

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 16,
            color: isWishlisted
                ? AppColors.wishlistActive
                : AppColors.wishlistInactive,
          ),
        ),
      ),
    );
  }
}

// ── Price row with Add to Cart / quantity stepper ─────────────────────────────
class _PriceAndCartRow extends StatefulWidget {
  final Product product;
  const _PriceAndCartRow({required this.product});

  @override
  State<_PriceAndCartRow> createState() => _PriceAndCartRowState();
}

class _PriceAndCartRowState extends State<_PriceAndCartRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _addController;
  late final Animation<double> _addScale;

  @override
  void initState() {
    super.initState();
    _addController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _addScale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _addController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    _addController
        .forward()
        .then((_) => _addController.reverse());
    context.read<CartProvider>().addToCart(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final quantity = cartProvider.quantityOf(widget.product.id);
    final inCart = quantity > 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Price column ──────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current price
              Text(
                '₹${widget.product.price.toStringAsFixed(0)}',
                style: AppTextStyles.priceText.copyWith(fontSize: 14),
              ),
              // Original price (strikethrough) if discounted
              if (widget.product.hasDiscount)
                Text(
                  '₹${widget.product.originalPrice!.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
            ],
          ),
        ),

        // ── Cart control ──────────────────────────────────────────────
        if (inCart)
          // Quantity stepper — shown when item already in cart
          _QuantityStepper(
            quantity: quantity,
            onIncrease: () => context
                .read<CartProvider>()
                .increaseQuantity(widget.product.id),
            onDecrease: () => context
                .read<CartProvider>()
                .decreaseQuantity(widget.product.id),
          )
        else
          // Add to Cart button
          ScaleTransition(
            scale: _addScale,
            child: GestureDetector(
              onTap: _handleAddToCart,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Quantity stepper (− qty +) ────────────────────────────────────────────────
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          _StepperButton(icon: Icons.remove_rounded, onTap: onDecrease),
          // Quantity label
          SizedBox(
            width: 22,
            child: Text(
              '$quantity',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Increase button
          _StepperButton(icon: Icons.add_rounded, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 26,
        height: 28,
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}
