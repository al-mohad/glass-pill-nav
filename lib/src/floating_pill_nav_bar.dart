import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/glass_pill_nav_item.dart';
import 'models/glass_pill_nav_style.dart';
import 'widgets/glass_pill_nav_scope.dart';
import 'widgets/nav_item_tile.dart';
import 'widgets/pill_indicator.dart';

/// A supreme, glassmorphic floating pill navigation bar.
class GlassPillNav extends StatefulWidget {
  /// The list of items to display in the navigation bar.
  final List<GlassPillNavItem> items;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Optional custom widget to display in the center of the navigation bar.
  final Widget? centerAction;

  /// Optional callback for when the center action button is tapped.
  final VoidCallback? onCenterActionTap;

  /// Optional callback for when a navigation tab is tapped.
  /// Returns the index of the tapped tab.
  final ValueChanged<int>? onTabTap;

  /// Styling configuration for the navigation bar.
  final GlassPillNavStyle? style;

  const GlassPillNav({
    super.key,
    required this.items,
    required this.currentIndex,
    this.centerAction,
    this.onCenterActionTap,
    this.onTabTap,
    this.style,
  });

  @override
  State<GlassPillNav> createState() => _GlassPillNavState();
}

class _GlassPillNavState extends State<GlassPillNav>
    with SingleTickerProviderStateMixin {
  AnimationController? _shimmerController;
  bool _isCenterPressed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initial check for shimmer. We'll resolve style in build.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final style = GlassPillNavStyle.resolve(context, widget.style);
    if (style.enableShimmer && !(_shimmerController?.isAnimating ?? false)) {
      _shimmerController?.repeat();
    }
  }

  @override
  void didUpdateWidget(GlassPillNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    final style = GlassPillNavStyle.resolve(context, widget.style);
    final controller = _shimmerController;
    if (controller == null) return;

    if (style.enableShimmer && !controller.isAnimating) {
      controller.repeat();
    } else if (!style.enableShimmer && controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = GlassPillNavStyle.resolve(context, widget.style);

    return GlassPillNavScope(
      style: style,
      shimmerController: _shimmerController!,
      child: Container(
        margin: style.margin,
        height: style.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: style.blurSigma,
              sigmaY: style.blurSigma,
            ),
            child: Container(
              padding: style.padding,
              decoration: BoxDecoration(
                color:
                    style.backgroundGradient == null ? style.baseColor : null,
                gradient: style.backgroundGradient,
                borderRadius: BorderRadius.circular(style.borderRadius),
                border: Border.all(
                  color: style.borderColor,
                  width: style.borderWidth,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final int totalSlots = widget.centerAction != null
                      ? widget.items.length + 1
                      : widget.items.length;
                  final double itemWidth = constraints.maxWidth / totalSlots;

                  // Calculate pill position
                  double pillLeft;
                  final int centerSlotIndex = widget.items.length ~/ 2;

                  if (widget.centerAction != null && _isCenterPressed) {
                    pillLeft = centerSlotIndex * itemWidth;
                  } else {
                    pillLeft = widget.currentIndex * itemWidth;
                    if (widget.centerAction != null) {
                      if (widget.currentIndex >= centerSlotIndex) {
                        pillLeft = (widget.currentIndex + 1) * itemWidth;
                      }
                    }
                  }

                  return Stack(
                    children: [
                      PillIndicator(
                        width: itemWidth,
                        left: pillLeft,
                      ),
                      Row(
                        children: _buildNavItems(itemWidth),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(double itemWidth) {
    final List<Widget> navWidgets = [];
    final int centerIndex = widget.items.length ~/ 2;

    for (int i = 0; i < widget.items.length; i++) {
      if (widget.centerAction != null && i == centerIndex) {
        navWidgets.add(_buildCenterAction());
      }

      navWidgets.add(
        NavItemTile(
          item: widget.items[i],
          isActive: i == widget.currentIndex,
          onTap: () => widget.onTabTap?.call(i),
        ),
      );
    }

    // Edge case handling for empty list or center at the end
    if (widget.centerAction != null &&
        navWidgets.length < 2 &&
        widget.items.isEmpty) {
      navWidgets.add(_buildCenterAction());
    } else if (widget.centerAction != null &&
        centerIndex == widget.items.length &&
        widget.items.isNotEmpty) {
      navWidgets.add(_buildCenterAction());
    }

    return navWidgets;
  }

  Widget _buildCenterAction() {
    final style = GlassPillNavStyle.resolve(context, widget.style);

    return Expanded(
      child: Semantics(
        label: 'Center action',
        button: true,
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onCenterActionTap?.call();
        },
        child: GestureDetector(
          onTapDown: (_) {
            HapticFeedback.lightImpact();
            setState(() => _isCenterPressed = true);
          },
          onTapUp: (_) {
            setState(() => _isCenterPressed = false);
            HapticFeedback.mediumImpact();
            widget.onCenterActionTap?.call();
          },
          onTapCancel: () => setState(() => _isCenterPressed = false),
          child: AnimatedScale(
            scale: _isCenterPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(style.borderRadius),
                boxShadow: _isCenterPressed
                    ? [
                        BoxShadow(
                          color: style.activeColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Center(child: widget.centerAction!),
            ),
          ),
        ),
      ),
    );
  }
}
