import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class ColorSwatchSelector extends StatelessWidget {
  final List<ProductColor> colors;
  final ProductColor selectedColor;
  final ValueChanged<ProductColor> onSelected;

  const ColorSwatchSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
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
            const Text('Color Palette', style: AppTextStyles.h3),
            Text(
              selectedColor.name,
              style: AppTextStyles.label.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: colors.map((c) {
            final isSelected = c.name == selectedColor.name;
            return GestureDetector(
              onTap: () => onSelected(c),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
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
}
