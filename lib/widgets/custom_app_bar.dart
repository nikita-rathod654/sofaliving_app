import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../providers/cart_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showCartIcon;
  final VoidCallback? onCartPressed;
  final bool isBrandTitle;

  const CustomAppBar({
    super.key,
    this.title = 'SOFALIVING',
    this.showBack = false,
    this.onBack,
    this.actions,
    this.showCartIcon = false,
    this.onCartPressed,
    this.isBrandTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: isBrandTitle ? AppTextStyles.brandHeader : AppTextStyles.h3,
      ),
      actions: [
        if (actions != null) ...actions!,
        if (showCartIcon)
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              final count = cart.totalItemCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                    onPressed: onCartPressed,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
