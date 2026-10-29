import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Brand Header Serif look
  static const TextStyle brandHeader = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 3.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle brandSubheader = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.textSecondary,
  );

  // Screen Titles
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Price Styles
  static const TextStyle priceHighlight = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceOriginal = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    color: AppColors.textMuted,
  );

  // Buttons & Labels
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textLight,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textSecondary,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    color: AppColors.textPrimary,
  );
}
