import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';

/// Network product image that fades in and degrades to a neutral placeholder
/// (tinted container + food icon) on load failure, so the layout never breaks.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.imageUrl, this.iconSize});

  final String imageUrl;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(iconSize: iconSize, showSpinner: true);
      },
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(iconSize: iconSize),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.iconSize, this.showSpinner = false});

  final double? iconSize;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: showSpinner
          ? SizedBox(
              width: 22.r,
              height: 22.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryLighter,
              ),
            )
          : Icon(
              Icons.eco_rounded,
              size: iconSize ?? 32.r,
              color: AppColors.primaryLighter,
            ),
    );
  }
}
