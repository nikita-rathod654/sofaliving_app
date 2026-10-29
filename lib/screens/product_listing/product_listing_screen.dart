import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_card.dart';
import '../../providers/product_provider.dart';
import '../product_details/product_details_screen.dart';
import 'filter_bottom_sheet.dart';

class ProductListingScreen extends StatefulWidget {
  final String? initialCategory;

  const ProductListingScreen({super.key, this.initialCategory});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Sofas', 'Sectionals', 'Recliners', 'Armchairs', 'Modular'];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false).selectCategory(widget.initialCategory!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showCartIcon: true,
        onCartPressed: () {
          // Switch tab or notify
        },
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          final products = provider.filteredProducts;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => provider.setSearchQuery(val),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                              },
                            )
                          : null,
                      hintText: 'Search by silhouette, boucle, linen...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // 2. Category Filter Pills Row
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Filters button
                    GestureDetector(
                      onTap: () => _openFilterSheet(context),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.tune, size: 14, color: AppColors.textPrimary),
                            SizedBox(width: 4),
                            Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    ..._categories.map((cat) {
                      final isSelected = provider.selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => provider.selectCategory(cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // 3. Header Count & Sort Dropdown Row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.selectedCategory == 'All' ? 'All Pieces' : provider.selectedCategory} (${products.length} craft pieces)',
                      style: AppTextStyles.h3.copyWith(fontSize: 14),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<ProductSortOption>(
                        value: provider.sortOption,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textPrimary),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        onChanged: (opt) {
                          if (opt != null) provider.setSortOption(opt);
                        },
                        items: const [
                          DropdownMenuItem(value: ProductSortOption.popularity, child: Text('Popularity')),
                          DropdownMenuItem(value: ProductSortOption.priceLowToHigh, child: Text('Price: Low to High')),
                          DropdownMenuItem(value: ProductSortOption.priceHighToLow, child: Text('Price: High to Low')),
                          DropdownMenuItem(value: ProductSortOption.topRated, child: Text('Top Rated')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Products Grid
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            const Text('No handcrafted pieces found', style: AppTextStyles.h3),
                            const SizedBox(height: 6),
                            const Text('Try adjusting your search or filters.', style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                                provider.resetFilters();
                                provider.selectCategory('All');
                              },
                              child: const Text('Reset All Filters', style: TextStyle(color: AppColors.accent)),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 0.55,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
