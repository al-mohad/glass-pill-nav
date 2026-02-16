import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/glass_pill_nav_item.dart';
import 'glass_pill_nav_scope.dart';
import 'shimmer_icon.dart';

class NavItemTile extends StatelessWidget {
  final GlassPillNavItem item;
  final bool isActive;
  final VoidCallback? onTap;

  const NavItemTile({
    super.key,
    required this.item,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = GlassPillNavScope.of(context).style;

    return Expanded(
      child: Semantics(
        label: item.label ?? 'Navigation item',
        selected: isActive,
        button: true,
        onTap: () {
          HapticFeedback.lightImpact();
          item.onTap?.call();
          onTap?.call();
        },
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            item.onTap?.call();
            onTap?.call();
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isActive && style.enableScaleAnimation
                    ? style.scaleAmount
                    : 1.0,
                duration: style.animationDuration,
                curve: style.animationCurve,
                child: ShimmerIcon(
                  icon: item.icon,
                  isActive: isActive,
                ),
              ),
              if (item.label != null && item.label!.isNotEmpty) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: style.animationDuration,
                  curve: style.animationCurve,
                  style: TextStyle(
                    color: isActive
                        ? style.activeColor
                        : style.activeColor.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: Text(item.label!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
