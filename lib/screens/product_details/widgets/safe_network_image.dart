import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SafeNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.cardBg,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: AppColors.textMuted),
      ),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}