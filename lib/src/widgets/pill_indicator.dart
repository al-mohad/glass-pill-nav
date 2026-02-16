import 'package:flutter/material.dart';

import 'glass_pill_nav_scope.dart';
import 'liquid_pill_indicator.dart';

class PillIndicator extends StatelessWidget {
  final double width;
  final double left;

  const PillIndicator({
    super.key,
    required this.width,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    final style = GlassPillNavScope.of(context).style;

    if (style.enableLiquidEffect) {
      return LiquidPillIndicator(
        width: width,
        left: left,
      );
    }

    return AnimatedPositioned(
      duration: style.animationDuration,
      curve: style.animationCurve,
      left: left,
      top: 6,
      bottom: 6,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: style.activeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(style.borderRadius - 6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
