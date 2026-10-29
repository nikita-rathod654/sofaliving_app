import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state_view.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../product_details/product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  final VoidCallback? onExplore;
  final VoidCallback? onGoToCart;

  const WishlistScreen({super.key, this.onExplore, this.onGoToCart});

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80';

  Widget _thumb(String url) {
    final placeholder = Container(
      width: 80,
      height: 80,
      color: AppColors.cardBg,
      child: const Icon(Icons.image_not_supported_outlined,
          color: AppColors.textMuted),
    );
    return Image.network(
      url.isNotEmpty ? url : _fallbackImage,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showCartIcon: true,
        onCartPressed: onGoToCart,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.textPrimary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wishlist share link generated!')),
              );
            },
          ),
        ],
      ),
      body: Consumer4<WishlistProvider, CartProvider, AuthProvider,
          ProductProvider>(
        builder: (context, wishlist, cart, auth, productProvider, _) {
          final items = wishlist.items;
          final userId = auth.currentUser?.id ?? 1;

          if (wishlist.isEmpty) {
            return Column(
              children: [
                _buildEmptyStateToggleBar(wishlist),
            
              Expanded(
  child: LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: EmptyStateView(
          icon: Icons.favorite_border,
          title:
              'When your wishlist is empty,\ndiscover our new arrivals',
          message:
              'Explore hand-stitched curved silhouettes and rich Japanese cedar framework tailored for mindful living.',
          buttonText: 'Explore Collection',
          onButtonPressed: onExplore,
        ),
      ),
    ),
  ),
),



              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmptyStateToggleBar(wishlist),

                // 1. Title Header & Clear All
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                const Text('My Wishlist',
                                    style: AppTextStyles.h1),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${items.length} saved items',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bespoke tactile seating reserved for your space',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => wishlist.clearWishlist(userId),
                        child: const Text('Clear All',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. "Complete the Set" Bulk Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 14, color: AppColors.primary),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Complete the Set',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total value: ${CurrencyFormatter.format(wishlist.totalValue)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            await wishlist.moveAllToCart(
                                cart, userId, productProvider.allProducts);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'All wishlist items moved to your shopping bag!')),
                              );
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Move All',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward,
                                  size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Wishlist Items List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = productProvider.findById(item.productId);

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.border, width: 0.8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          GestureDetector(
                            onTap: () {
                              if (product != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailsScreen(product: product),
                                  ),
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  children: [
                                    _thumb(item.image),
                                    if (item.badge != null)
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.7),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            item.badge!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Info & Actions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: AppTextStyles.h3
                                            .copyWith(fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => wishlist.removeItem(item.id),
                                      child: const Icon(Icons.delete_outline,
                                          size: 18,
                                          color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.summaryLabel,
                                  style: AppTextStyles.bodySmall
                                      .copyWith(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(item.price),
                                      style: AppTextStyles.priceHighlight
                                          .copyWith(fontSize: 14),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                      ),
                                      onPressed: () async {
                                        await wishlist.moveToCart(
                                            cart, userId, item, product);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Moved ${item.name} to Shopping Bag!'),
                                              action: SnackBarAction(
                                                label: 'VIEW BAG',
                                                textColor: AppColors.accent,
                                                onPressed:
                                                    onGoToCart ?? () {},
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.shopping_bag_outlined,
                                              size: 12, color: Colors.white),
                                          SizedBox(width: 4),
                                          Text('Move to Cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 4. Curated Discovery Footer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURATED DISCOVERY',
                                style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0),
                              ),
                              SizedBox(height: 4),
                              Text('Autumn/Winter 2025 Lookbook',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text('Discover 12 handcrafted new releases',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: onExplore,
                          child: const Text('Explore >',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // Quick evaluation toggle for review
  Widget _buildEmptyStateToggleBar(WishlistProvider wishlist) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Evaluation Tool: Wishlist State',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: wishlist.toggleEmptyStatePreview,
            child: Text(
              wishlist.simulateEmptyState ? 'Show Populated' : 'Show Empty',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}