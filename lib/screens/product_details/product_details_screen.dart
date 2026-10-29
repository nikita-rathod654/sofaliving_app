import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/quantity_control.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/color_swatch_selector.dart';
import 'widgets/fabric_selector.dart';
import 'widgets/seating_selector.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductColor _selectedColor;
  late ProductFabric _selectedFabric;
  late SeatingOption _selectedSeating;
  int _quantity = 1;
  int _activeImageIndex = 0;
  final PageController _pageController = PageController();

  bool _isDimensionsExpanded = false;
  bool _isCareExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.isNotEmpty
        ? widget.product.colors.first
        : ProductColor(name: 'Warm Beige', hex: '#D8C4B6');
    _selectedFabric = widget.product.fabrics.isNotEmpty
        ? widget.product.fabrics.first
        : ProductFabric(name: 'Belgian Linen', priceModifier: 0, tag: 'Included');
    _selectedSeating = widget.product.seatingOptions.length > 1
        ? widget.product.seatingOptions[1] // standard 3-seater
        : widget.product.seatingOptions.first;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _calculatedUnitPrice {
    return widget.product.calculatePrice(
      fabric: _selectedFabric,
      seating: _selectedSeating,
    );
  }

  double get _calculatedTotalPrice => _calculatedUnitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : ['https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80'];

    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        title: 'SOFALIVING',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Atelier share link copied to clipboard')),
              );
            },
          ),
          Consumer2<WishlistProvider, AuthProvider>(
            builder: (context, wishlist, auth, _) {
              final isWishlisted = wishlist.isProductWishlisted(widget.product.id);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? AppColors.error : AppColors.textPrimary,
                  size: 22,
                ),
                onPressed: () {
                  wishlist.toggleWishlist(
                    userId: auth.currentUser?.id ?? 1,
                    product: widget.product,
                    color: _selectedColor.name,
                    fabric: _selectedFabric.name,
                    seating: _selectedSeating.name,
                    price: _calculatedUnitPrice,
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image Carousel
            Stack(
              children: [
                SizedBox(
                  height: 320,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => _activeImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => Container(
                          color: AppColors.cardBg,
                          child: const Center(
                            child: Icon(Icons.chair, size: 60, color: AppColors.textMuted),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // "3D Studio" Pill
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.view_in_ar, size: 14, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          '3D STUDIO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Page Indicator Counter e.g. "1 / 6"
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_activeImageIndex + 1} / ${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Pagination Dots Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final isActive = index == _activeImageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Rating & Stock Info



                  // 2. Rating & Stock Info
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 15,
                            color: AppColors.rating,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'In Stock • Ships in 5-7 days',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),


               







                  // 3. Title
                  Text(widget.product.name, style: AppTextStyles.h1),
                  const SizedBox(height: 8),

                  // 4. Dynamic Price Display & Configured Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        CurrencyFormatter.format(_calculatedUnitPrice),
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 22,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.product.originalPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          CurrencyFormatter.format(widget.product.originalPrice!),
                          style: AppTextStyles.priceOriginal.copyWith(fontSize: 15),
                        ),
                      ],
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.accent, width: 0.8),
                        ),
                        child: const Text(
                          'Configured',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 5. Description
                  Text(
                    widget.product.description,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // 6. Interactive Customiser 1: Color Palette
                  ColorSwatchSelector(
                    colors: widget.product.colors,
                    selectedColor: _selectedColor,
                    onSelected: (color) => setState(() => _selectedColor = color),
                  ),
                  const SizedBox(height: 20),

                  // 7. Interactive Customiser 2: Fabric Material
                  FabricSelector(
                    fabrics: widget.product.fabrics,
                    selectedFabric: _selectedFabric,
                    onSelected: (fabric) => setState(() => _selectedFabric = fabric),
                  ),
                  const SizedBox(height: 20),

                  // 8. Interactive Customiser 3: Seating Configuration
                  SeatingSelector(
                    seatingOptions: widget.product.seatingOptions,
                    selectedSeating: _selectedSeating,
                    onSelected: (seating) => setState(() => _selectedSeating = seating),
                  ),
                  const SizedBox(height: 24),

                  // 9. Quantity Control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity', style: AppTextStyles.h3),
                          SizedBox(height: 2),
                          Text('Custom build-to-order units', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      QuantityControl(
                        quantity: _quantity,
                        onChanged: (newQty) => setState(() => _quantity = newQty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // 10. Accordion: Dimensions & Specifications
                  _buildAccordion(
                    title: 'Dimensions & Specifications',
                    isExpanded: _isDimensionsExpanded,
                    onToggle: () => setState(() => _isDimensionsExpanded = !_isDimensionsExpanded),
                    content: widget.product.specifications != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.product.specifications!.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: AppTextStyles.bodyMedium),
                                    Text(
                                      '${entry.value}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : const Text('Standard Atelier Dimensions applied.', style: AppTextStyles.bodyMedium),
                  ),
                  const Divider(),

                  // 11. Accordion: Care & Maintenance
                  _buildAccordion(
                    title: 'Care & Maintenance',
                    isExpanded: _isCareExpanded,
                    onToggle: () => setState(() => _isCareExpanded = !_isCareExpanded),
                    content: widget.product.careInstructions != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.product.careInstructions!.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '• ${entry.key}: ${entry.value}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              );
                            }).toList(),
                          )
                        : const Text('Dry clean and soft vacuuming recommended.', style: AppTextStyles.bodyMedium),
                  ),
                  const SizedBox(height: 20),

                  // 12. Atelier Trust Badges
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TrustBadge(icon: Icons.verified_user_outlined, label: '10-Yr Frame\nWarranty'),
                        _TrustBadge(icon: Icons.dry_cleaning_outlined, label: 'White Glove\nAssembly'),
                        _TrustBadge(icon: Icons.eco_outlined, label: '100% Organic\nProvenance'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Spacing for sticky bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      // Sticky Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Total Price & Selected configuration breakdown
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Total: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.format(_calculatedTotalPrice),
                          style: AppTextStyles.h2.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedSeating.name.split(' (').first} • ${_selectedFabric.name.replaceAll('Belgian ', '')} • ${_selectedColor.name}',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Add to Cart Black Button
              Expanded(
                flex: 3,
                child: Consumer2<CartProvider, AuthProvider>(
                  builder: (context, cart, auth, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        final userId = auth.currentUser?.id ?? 1;
                        await cart.addItem(
                          userId: userId,
                          product: widget.product,
                          color: _selectedColor.name,
                          fabric: _selectedFabric.name,
                          seating: _selectedSeating.name,
                          quantity: _quantity,
                          unitPrice: _calculatedUnitPrice,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primary,
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text('Added ${widget.product.name} to bag!'),
                                ),
                              ],
                            ),
                            action: SnackBarAction(
                              label: 'VIEW BAG',
                              textColor: AppColors.accent,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Add to Cart • ${CurrencyFormatter.format(_calculatedTotalPrice)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15)),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: content,
          ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
