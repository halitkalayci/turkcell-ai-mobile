import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../theme/app_colors.dart';

/// Horizontal category card widget.
/// Per AGENTS.md Section 5.1: UI layer has no business logic.
/// Per styleguide.md Section 3: Uses AppColors design tokens.
/// 
/// Design:
/// - Category name (primary text)
/// - Parent category name below (if exists)
/// - Edit icon on the right
class CategoryCard extends StatelessWidget {
  final Category category;
  final String? parentName;
  final VoidCallback? onTap;
  final VoidCallback? onEditPressed;

  const CategoryCard({
    super.key,
    required this.category,
    this.parentName,
    this.onTap,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppColors.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
        border: Border.all(
          color: AppColors.textHint.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
        child: Padding(
          padding: const EdgeInsets.all(AppColors.spacingStandard),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.imagePlaceholder,
                  borderRadius: BorderRadius.circular(AppColors.radiusSearchBar),
                ),
                child: Icon(
                  Icons.category_outlined,
                  color: AppColors.iconInactive,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: AppColors.spacingStandard),
              
              // Category info (name + parent)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category name
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Parent category name (if exists)
                    if (parentName != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.subdirectory_arrow_right,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              parentName!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Edit icon
              IconButton(
                onPressed: onEditPressed,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.iconInactive,
                  size: 22,
                ),
                splashRadius: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
