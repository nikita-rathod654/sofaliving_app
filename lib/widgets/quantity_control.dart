import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: quantity > min ? () => onChanged(quantity - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: AppTextStyles.h3.copyWith(fontSize: 14),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: quantity < max ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }
}
