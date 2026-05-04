// lib/screens/cart_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// Shopping cart page: lists all cart items with quantity controls,
// price summary, and a "Place Order" button.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          // Clear cart button
          Consumer<CartProvider>(
            builder: (context, cart, _) => cart.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => _confirmClear(context, cart),
                    child: Text(
                      'Clear all',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return _EmptyCart();

          return Column(
            children: [
              // ── Cart items list ────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.spaceM),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppConstants.spaceS),
                  itemBuilder: (context, index) {
                    return _CartItemCard(item: cart.items[index]);
                  },
                ),
              ),

              // ── Order summary + CTA ────────────────────────────────────
              _OrderSummary(cart: cart),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, CartProvider cart) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) cart.clearCart();
  }
}

// ── Cart item row card ────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            child: Image.network(
              item.product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.textHint),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceS),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.product.unit,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: AppConstants.spaceXS),
                Text(
                  '₹${item.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.priceText,
                ),
              ],
            ),
          ),

          // Quantity stepper
          Column(
            children: [
              // Remove completely
              GestureDetector(
                onTap: () => cart.removeFromCart(item.product.id),
                child: const Icon(Icons.delete_outline_rounded,
                    size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.spaceXS),
              // Stepper
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepBtn(
                      icon: Icons.remove_rounded,
                      onTap: () => cart.decreaseQuantity(item.product.id),
                    ),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _StepBtn(
                      icon: Icons.add_rounded,
                      onTap: () => cart.increaseQuantity(item.product.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 28,
        height: 30,
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}

// ── Order summary panel ────────────────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: '₹${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: AppConstants.spaceXS),
          _SummaryRow(
            label: 'Delivery',
            value: cart.deliveryCharge == 0
                ? 'FREE'
                : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
            valueColor: cart.deliveryCharge == 0 ? AppColors.primary : null,
          ),
          const Divider(height: AppConstants.spaceXL),
          _SummaryRow(
            label: 'Total',
            value: '₹${cart.grandTotal.toStringAsFixed(0)}',
            isTotal: true,
          ),
          const SizedBox(height: AppConstants.spaceM),

          // Place Order button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Order placed successfully! 🎉'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                );
                cart.clearCart();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spaceM,
                ),
              ),
              child: Text(
                'Place Order • ₹${cart.grandTotal.toStringAsFixed(0)}',
                style: AppTextStyles.buttonText.copyWith(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.headingSmall
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.headingMedium.copyWith(color: AppColors.primary)
              : AppTextStyles.labelLarge.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}

// ── Empty cart illustration ────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 80)),
          const SizedBox(height: AppConstants.spaceM),
          Text('Your cart is empty', style: AppTextStyles.headingMedium),
          const SizedBox(height: AppConstants.spaceXS),
          Text(
            'Add some fresh products to get started!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXL),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
