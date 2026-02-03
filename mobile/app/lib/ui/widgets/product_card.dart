import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../core/formatters/price_formatter.dart';
import '../../core/formatters/product_formatter.dart';
import '../theme/app_colors.dart';

/// Product card widget matching reference design.
/// Per AGENTS.md Section 5.1: UI layer has no business logic.
/// Per styleguide.md Section 3: Uses AppColors design tokens.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite icon
            Expanded(
              child: Stack(
                children: [
                  // Product image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.imagePlaceholder,
                      borderRadius: BorderRadius.circular(AppColors.radiusCard),
                    ),
                    child: _buildImage(),
                  ),
                  
                  // Favorite icon (top right)
                  Positioned(
                    top: AppColors.spacingSmall,
                    right: AppColors.spacingSmall,
                    child: GestureDetector(
                      onTap: onFavoritePressed,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.cardBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite 
                              ? AppColors.iconFavoriteActive 
                              : AppColors.iconFavoriteInactive,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Product info
            Padding(
              padding: const EdgeInsets.all(AppColors.spacingCard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand name
                  Text(
                    ProductFormatter.extractBrand(product.name),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Full product name
                  Text(
                    product.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    PriceFormatter.format(product.price),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (product.hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Image.network(
          product.imageUrl!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: AppColors.iconPlaceholder,
      ),
    );
  }
}
