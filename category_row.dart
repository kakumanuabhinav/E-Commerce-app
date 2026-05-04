// lib/widgets/category_row.dart
// ─────────────────────────────────────────────────────────────────────────────
// Horizontally scrollable row of category chips.
// The selected chip is highlighted and the provider updates the filtered list.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/products_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';

class CategoryRow extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryRow({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Watch selectedCategoryId from the provider so the row rebuilds on change
    final selectedId = context.watch<ProductsProvider>().selectedCategoryId;

    return SizedBox(
      height: AppConstants.categoryCircleSize + 36, // circle + label + padding
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppConstants.spaceS),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedId;

          return _CategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () {
              // Update provider — no setState needed here
              context.read<ProductsProvider>().selectCategory(category.id);
            },
          );
        },
      ),
    );
  }
}

// ── Individual category chip ──────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: AppConstants.categoryItemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon circle ─────────────────────────────────────────────
            AnimatedContainer(
              duration: AppConstants.animFast,
              width: AppConstants.categoryCircleSize,
              height: AppConstants.categoryCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? category.color
                    : category.color.withOpacity(0.12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: category.color.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                category.icon,
                size: AppConstants.categoryIconSize * 0.85,
                color: isSelected ? Colors.white : category.color,
              ),
            ),

            const SizedBox(height: AppConstants.spaceXXS + 2),

            // ── Label ────────────────────────────────────────────────────
            Text(
              category.name,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
