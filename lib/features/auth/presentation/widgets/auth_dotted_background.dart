import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/app_colors.dart';

/// Faint dot-grid texture used behind the auth cards (the designs'
/// "bento texture"). [spacing] controls the grid pitch in logical pixels.
class AuthDottedBackground extends StatelessWidget {
  const AuthDottedBackground({
    super.key,
    this.spacing = 24.0,
    this.dotRadius = 1.0,
  });

  final double spacing;
  final double dotRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotGridPainter(spacing: spacing, dotRadius: dotRadius),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.spacing, required this.dotRadius});

  final double spacing;
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    for (double y = 2; y < size.height; y += spacing) {
      for (double x = 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) =>
      oldDelegate.spacing != spacing || oldDelegate.dotRadius != dotRadius;
}
