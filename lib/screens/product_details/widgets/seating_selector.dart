import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class SeatingSelector extends StatelessWidget {
  final List<SeatingOption> seatingOptions;
  final SeatingOption selectedSeating;
  final ValueChanged<SeatingOption> onSelected;

  const SeatingSelector({
    super.key,
    required this.seatingOptions,
    required this.selectedSeating,
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
            const Text('Configuration & Scale', style: AppTextStyles.h3),
            Text(
              'Modular System',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: seatingOptions.map((s) {
            final isSelected = s.name == selectedSeating.name;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(s),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
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
                      Text(
                        s.name.split(' (').first,
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
                        s.tag.isNotEmpty
                            ? s.tag
                            : (s.priceModifier == 0
                                ? 'Standard'
                                : (s.priceModifier > 0
                                    ? '+₹${s.priceModifier.toInt()}'
                                    : '−₹${s.priceModifier.abs().toInt()}')),
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
}
