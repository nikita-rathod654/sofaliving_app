import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class FabricSelector extends StatelessWidget {
  final List<ProductFabric> fabrics;
  final ProductFabric selectedFabric;
  final ValueChanged<ProductFabric> onSelected;

  const FabricSelector({
    super.key,
    required this.fabrics,
    required this.selectedFabric,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Material Fabric', style: AppTextStyles.h3),
            Text(
              'Belgian Textured',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: fabrics.map((f) {
            final isSelected = f.name == selectedFabric.name;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getFabricIcon(f.name),
                        size: 18,
                        color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        f.name.replaceAll('Belgian ', '').replaceAll('Tactile ', '').replaceAll('Nappa ', ''),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f.tag.isNotEmpty ? f.tag : (f.priceModifier == 0 ? 'Included' : '+₹${f.priceModifier.toInt()}'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.accent : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getFabricIcon(String name) {
    if (name.toLowerCase().contains('velvet')) return Icons.auto_awesome;
    if (name.toLowerCase().contains('leather')) return Icons.shield_outlined;
    return Icons.texture;
  }
}
