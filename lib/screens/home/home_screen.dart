import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../product_details/product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  Widget _networkImage(String url) {
    final placeholder = Container(
      color: AppColors.cardBg,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: AppColors.textMuted),
      ),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Brand Header
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'SOFALIVING',
                        style: AppTextStyles.brandHeader,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: auth.isDbConnected
                                        ? AppColors.successLight
                                        : AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: auth.isDbConnected
                                          ? AppColors.success
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    auth.isDbConnected ? 'MySQL' : 'Demo DB',
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 40,
                              ),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Atelier Notification: Autumn Velvet Series is now live!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return GestureDetector(
                                  onTap: () => _showUserMenu(context, auth),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      auth.currentUser?.fullName.isNotEmpty ==
                                              true
                                          ? auth.currentUser!.fullName[0]
                                              .toUpperCase()
                                          : 'A',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 6.0),
                child: GestureDetector(
                  onTap: () => onTabChange(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search,
                            color: AppColors.textSecondary, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Find your perfect sofa',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 13),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.tune,
                            color: AppColors.textPrimary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Hero Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: const NetworkImage(
                        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
                      ),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {},
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.75),
                          Colors.black.withValues(alpha: 0.2),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ARTISAN WORKSHOP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Crafted For Serenity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bespoke handcrafted living room pieces',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => onTabChange(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Explore Collection',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward,
                                    size: 14, color: AppColors.textPrimary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Category Pills Row
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  final cats = [
                    'All',
                    'Sofas',
                    'Sectionals',
                    'Recliners',
                    'Modular'
                  ];
                  return SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                        final cat = cats[index];
                        final isSelected = provider.selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            provider.selectCategory(cat);
                            onTabChange(1);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 5. Featured Sofas Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Featured Sofas', style: AppTextStyles.h2),
                    GestureDetector(
                      onTap: () => onTabChange(1),
                      child: const Row(
                        children: [
                          Text(
                            'View all',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary),
                          ),
                          Icon(Icons.chevron_right,
                              size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Featured List
              Consumer2<ProductProvider, WishlistProvider>(
                builder: (context, productProvider, wishlistProvider, _) {
                  final featured = productProvider.featuredSofas;
                  final auth =
                      Provider.of<AuthProvider>(context, listen: false);

                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featured.length,
                      itemBuilder: (context, index) {
                        final product = featured[index];
                        final isWishlisted =
                            wishlistProvider.isProductWishlisted(product.id);

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            width: 170,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.border, width: 0.8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.25,
                                      child: _networkImage(
                                        product.images.isNotEmpty
                                            ? product.images[0]
                                            : '',
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          wishlistProvider.toggleWishlist(
                                            userId: auth.currentUser?.id ?? 1,
                                            product: product,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isWishlisted
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 14,
                                            color: isWishlisted
                                                ? AppColors.error
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              size: 11,
                                              color: AppColors.rating),
                                          const SizedBox(width: 3),
                                          Text('${product.rating}',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.name,
                                        style: AppTextStyles.h3
                                            .copyWith(fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        CurrencyFormatter.format(
                                            product.basePrice),
                                        style: AppTextStyles.priceHighlight
                                            .copyWith(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 6. Section "MODULAR CONFIG"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) {
                    final oslo = provider.findBySlug('oslo-modular') ??
                        (provider.allProducts.isNotEmpty
                            ? provider.allProducts.first
                            : null);

                    if (oslo == null) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.8,
                            child: _networkImage(
                              oslo.images.isNotEmpty ? oslo.images[0] : '',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'MODULAR CONFIG',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(oslo.name, style: AppTextStyles.h2),
                                const SizedBox(height: 4),
                                Text(oslo.subtitle,
                                    style: AppTextStyles.bodyMedium),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('From',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.textMuted)),
                                        Text(
                                            CurrencyFormatter.format(
                                                oslo.basePrice),
                                            style:
                                                AppTextStyles.priceHighlight),
                                      ],
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProductDetailsScreen(
                                                    product: oslo),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Configure',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
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
              ),
              const SizedBox(height: 24),

              // 7. Section "NEW ARRIVALS"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'NEW ARRIVALS',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Autumn Slate',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Tactile Velvet Textures',
                          style: AppTextStyles.h2),
                      const SizedBox(height: 6),
                      const Text(
                        'Explore 18 new muted mineral velvets and customizable modular depth options.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ...[
                            AppColors.swatchForestEmerald,
                            AppColors.swatchSlateTeal,
                            AppColors.swatchWarmBeige,
                            AppColors.swatchCharcoal,
                          ].map((color) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                ),
                              )),
                          const SizedBox(width: 4),
                          const Flexible(
                            child: Text(
                              '+14 fabrics',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textMuted),
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            onPressed: () => onTabChange(1),
                            child: const Text('Discover',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        auth.currentUser?.fullName.isNotEmpty == true
                            ? auth.currentUser!.fullName[0]
                            : 'U',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth.currentUser?.fullName ?? 'Guest User',
                              style: AppTextStyles.h2),
                          Text(auth.currentUser?.email ?? 'demo@example.com',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined,
                      color: AppColors.primary),
                  title: const Text('MySQL Database Sync'),
                  subtitle: Text(auth.isDbConnected
                      ? 'Connected (Port 5000)'
                      : 'Offline (Local Standby)'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(ctx);
                      await auth.checkDbStatus();
                      navigator.pop();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(auth.isDbConnected
                              ? 'MySQL Connected!'
                              : 'MySQL Server offline. Using local standby.'),
                        ),
                      );
                    },
                    child: const Text('Test Sync',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.switch_account_outlined,
                      color: AppColors.primary),
                  title: const Text('Quick Demo Login (Aarav Mehta)'),
                  subtitle: const Text('aarav.mehta@example.com'),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(ctx);
                    await auth.loginAsDemo();
                    navigator.pop();
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Switched to Demo Account (Aarav Mehta)')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text('Log Out',
                      style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    auth.logout();
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}