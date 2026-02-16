import 'package:flutter/material.dart';

import 'glass_pill_nav_scope.dart';

class ShimmerIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const ShimmerIcon({
    super.key,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final scope = GlassPillNavScope.of(context);
    final style = scope.style;

    if (!isActive || !style.enableShimmer) {
      return Icon(
        icon,
        color: isActive
            ? style.activeColor
            : style.activeColor.withValues(alpha: 0.5),
        size: 28,
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: scope.shimmerController,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  style.activeColor.withValues(alpha: 0.8),
                  style.activeColor,
                  style.activeColor.withValues(alpha: 0.8),
                ],
                stops: const [0.1, 0.5, 0.9],
                transform: _GradientRotation(
                  scope.shimmerController.value * 2 * 3.14159,
                ),
              ).createShader(bounds);
            },
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          );
        },
      ),
    );
  }
}

class _GradientRotation extends GradientTransform {
  final double rotation;
  const _GradientRotation(this.rotation);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final double centerWidth = bounds.width / 2;
    final double centerHeight = bounds.height / 2;
    return Matrix4.identity()
      ..translate(centerWidth, centerHeight, 0.0)
      ..rotateZ(rotation)
      ..translate(-centerWidth, -centerHeight, 0.0);
  }
}
