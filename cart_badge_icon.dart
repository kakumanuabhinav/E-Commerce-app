// lib/widgets/cart_badge_icon.dart
// ─────────────────────────────────────────────────────────────────────────────
// App bar action icon that shows the shopping cart with a badge
// displaying the current item count. Updates automatically via Provider.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';

class CartBadgeIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const CartBadgeIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Use Selector to only rebuild when totalItemCount changes
    final itemCount = context.select<CartProvider, int>(
      (cart) => cart.totalItemCount,
    );

    return IconButton(
      onPressed: onTap,
      tooltip: 'Shopping Cart',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 26),
          // Badge — only visible when cart has items
          if (itemCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    itemCount > 99 ? '99+' : '$itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
