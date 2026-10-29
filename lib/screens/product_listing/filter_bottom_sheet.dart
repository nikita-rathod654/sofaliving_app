import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../../providers/product_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _currentMaxPrice;

  final List<String> _materials = ['Boucle', 'Velvet', 'Linen', 'Leatherette'];
  final List<String> _seatings = ['2-Seater', '3-Seater', 'L-Shape', 'Modular'];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    _currentMaxPrice = provider.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final matchCount = provider.filteredProducts.length;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Filter Sofas', style: AppTextStyles.h2),
                      Text(
                        'Refine by crafted materials & dimension',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 1. Price Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Price Range', style: AppTextStyles.h3),
                  Text(
                    'Up to ${CurrencyFormatter.format(_currentMaxPrice)}',
                    style: AppTextStyles.h3.copyWith(color: AppColors.accent, fontSize: 14),
                  ),
                ],
              ),
              Slider(
                value: _currentMaxPrice,
                min: 30000,
                max: 120000,
                divisions: 18,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (val) {
                  setState(() => _currentMaxPrice = val);
                  provider.setPriceRange(provider.minPrice, val);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹30,000', style: AppTextStyles.bodySmall),
                  Text('₹1,20,000+', style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Material Provenance
              const Text('Material Provenance', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _materials.map((mat) {
                  final isSelected = provider.selectedMaterials.contains(mat);
                  return FilterChip(
                    label: Text(mat),
                    selected: isSelected,
                    onSelected: (_) => provider.toggleMaterialFilter(mat),
                    backgroundColor: AppColors.cardBg,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 3. Seating Configuration
              const Text('Seating Configuration', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _seatings.map((seat) {
                  final isSelected = provider.selectedSeating.contains(seat);
                  return FilterChip(
                    label: Text(seat),
                    selected: isSelected,
                    onSelected: (_) => provider.toggleSeatingFilter(seat),
                    backgroundColor: AppColors.cardBg,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // 4. Action Buttons (Reset & Show Pieces)
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      provider.resetFilters();
                      setState(() => _currentMaxPrice = 120000);
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Show $matchCount Pieces',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
