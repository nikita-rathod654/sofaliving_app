import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/currency_formatter.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  Widget _placeholder() {
    return Container(
      color: AppColors.cardBg,
      child: const Center(
        child: Icon(Icons.chair_outlined, size: 40, color: AppColors.textMuted),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image takes whatever height is left after the text block
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isEmpty
                      ? _placeholder()
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _placeholder(),
                        ),
                  // Wishlist heart
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer2<WishlistProvider, AuthProvider>(
                      builder: (context, wishlist, auth, _) {
                        final isWishlisted =
                            wishlist.isProductWishlisted(product.id);
                        final userId = auth.currentUser?.id ?? 1;

                        return GestureDetector(
                          onTap: () {
                            wishlist.toggleWishlist(
                              userId: userId,
                              product: product,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: isWishlisted
                                  ? AppColors.error
                                  : AppColors.textPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Colours / fabrics pill
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${product.colors.length} Colours  •  ${product.fabrics.length} Fabrics',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product details (natural height)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.rating),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${product.rating} (${product.reviewCount})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    style: AppTextStyles.h3.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.badge ?? product.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'starting',
                              style: TextStyle(
                                  fontSize: 9, color: AppColors.textMuted),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                CurrencyFormatter.format(product.basePrice),
                                style: AppTextStyles.priceHighlight
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}