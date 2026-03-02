import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'models/glass_pill_nav_item.dart';
import 'models/glass_pill_nav_style.dart';
import 'widgets/center_action_button.dart';
import 'widgets/glass_pill_nav_scope.dart';
import 'widgets/nav_item_tile.dart';
import 'widgets/pill_indicator.dart';

/// A supreme, glassmorphic floating pill navigation bar.
class GlassPillNav extends StatefulWidget {
  /// The list of items to display in the navigation bar.
  final List<GlassPillNavItem> items;

  /// The list of extra items to reveal when expanded (for expandable mode).
  final List<GlassPillNavItem>? expandableItems;

  /// The index of the currently selected item.
  final int currentIndex;

  /// Optional custom widget to display in the center of the navigation bar.
  final Widget? centerAction;

  /// Optional widget to display in the center when expanded (e.g., a close icon).
  final Widget? expandedCentralAction;

  /// Optional callback for when the center action button is tapped.
  final VoidCallback? onCenterActionTap;

  /// Optional callback for when a navigation tab is tapped.
  /// Returns the index of the tapped tab.
  final ValueChanged<int>? onTabTap;

  /// Styling configuration for the navigation bar.
  final GlassPillNavStyle? style;

  /// Optional scroll controller to enable auto-collapse behavior.
  final ScrollController? scrollController;

  /// Whether the central button should support expansion.
  final bool enableExpandableCentral;

  const GlassPillNav({
    super.key,
    required this.items,
    required this.currentIndex,
    this.centerAction,
    this.onCenterActionTap,
    this.onTabTap,
    this.style,
    this.scrollController,
  })  : expandableItems = null,
        expandedCentralAction = null,
        enableExpandableCentral = false;

  const GlassPillNav.expandable({
    super.key,
    required this.items,
    required this.expandableItems,
    required this.currentIndex,
    this.centerAction,
    this.expandedCentralAction,
    this.onTabTap,
    this.style,
    this.scrollController,
    this.enableExpandableCentral = true,
  }) : onCenterActionTap = null;

  const GlassPillNav.morphing({
    super.key,
    required this.items,
    required this.currentIndex,
    this.centerAction,
    this.onTabTap,
    this.style,
    this.scrollController,
  })  : expandableItems = null,
        expandedCentralAction = null,
        onCenterActionTap = null,
        enableExpandableCentral = false;

  @override
  State<GlassPillNav> createState() => _GlassPillNavState();
}

class _GlassPillNavState extends State<GlassPillNav>
    with TickerProviderStateMixin {
  AnimationController? _shimmerController;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  // For scroll-reactive behavior
  late AnimationController _scrollController;
  late Animation<double> _scrollAnimation;

  bool _isCenterPressed = false;
  bool _isExpanded = false;
  bool _isShrunk = false;
  bool _isMorphed = false;

  bool get _isMorphingMode =>
      widget.items.isNotEmpty &&
      widget.expandableItems == null &&
      widget.onCenterActionTap == null &&
      !widget.enableExpandableCentral;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _expandController = AnimationController(
      vsync: this,
      duration:
          widget.style?.expandDuration ?? const Duration(milliseconds: 400),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: widget.style?.expandCurve ?? Curves.easeOutBack,
      reverseCurve: (widget.style?.expandCurve ?? Curves.easeOutBack).flipped,
    );

    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollAnimation = CurvedAnimation(
      parent: _scrollController,
      curve: Curves.easeInOutCubic,
    );

    widget.scrollController?.addListener(_onScroll);
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
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }

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
    widget.scrollController?.removeListener(_onScroll);
    _shimmerController?.dispose();
    _expandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = widget.scrollController;
    if (controller == null) return;

    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isShrunk && controller.offset > 50) {
        setState(() => _isShrunk = true);
        _scrollController.forward();
        _collapse(); // Collapse expansion if scrolling down
      }
    } else if (controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isShrunk) {
        setState(() => _isShrunk = false);
        _scrollController.reverse();
      }
    }
  }

  void _toggleExpand() {
    if (_isMorphingMode) {
      setState(() => _isMorphed = !_isMorphed);
      HapticFeedback.mediumImpact();
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
        HapticFeedback.mediumImpact();
      } else {
        _expandController.reverse();
        HapticFeedback.lightImpact();
      }
    });
  }

  void _collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _expandController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = GlassPillNavStyle.resolve(context, widget.style);

    return PopScope(
      canPop: !_isExpanded,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isExpanded) {
          _collapse();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Tap-outside overlay
          if (_isExpanded)
            GestureDetector(
              onTap: _collapse,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),

          // Expanded Action Items
          if (widget.expandableItems != null)
            Positioned(
              bottom: style.height + (style.margin as EdgeInsets).bottom + 20,
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  final value = _expandAnimation.value;
                  if (value == 0) return const SizedBox.shrink();

                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _buildExpandedItems(style),
              ),
            ),

          // Main Nav Bar with Scroll Animation
          AnimatedBuilder(
            animation: _scrollAnimation,
            builder: (context, child) {
              final scrollValue = _scrollAnimation.value;
              final currentHeight =
                  lerpDouble(style.height, style.shrunkHeight, scrollValue)!;
              final currentMargin = EdgeInsets.lerp(
                style.margin as EdgeInsets,
                (style.margin as EdgeInsets).copyWith(bottom: 10),
                scrollValue,
              )!;

              return GlassPillNavScope(
                style: style,
                shimmerController: _shimmerController!,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  margin: currentMargin,
                  height: currentHeight,
                  width: _isMorphingMode && !_isMorphed ? style.height : null,
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
                          color: style.backgroundGradient == null
                              ? style.baseColor
                              : null,
                          gradient: style.backgroundGradient,
                          borderRadius:
                              BorderRadius.circular(style.borderRadius),
                          border: Border.all(
                            color: style.borderColor,
                            width: style.borderWidth,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bool showItems =
                                !_isMorphingMode || _isMorphed;
                            int totalSlots = widget.items.length;
                            if (widget.centerAction != null ||
                                widget.enableExpandableCentral ||
                                _isMorphingMode) {
                              totalSlots =
                                  showItems ? widget.items.length + 1 : 1;
                              if (_isMorphingMode && _isMorphed) totalSlots++;
                            }
                            final double itemWidth =
                                constraints.maxWidth / totalSlots;

                            // Calculate pill position
                            double pillLeft;
                            final int centerSlotIndex =
                                widget.items.length ~/ 2;

                            if ((widget.centerAction != null ||
                                    widget.enableExpandableCentral ||
                                    _isMorphingMode) &&
                                _isCenterPressed) {
                              pillLeft = centerSlotIndex * itemWidth;
                            } else {
                              pillLeft = widget.currentIndex * itemWidth;
                              if (widget.centerAction != null ||
                                  widget.enableExpandableCentral ||
                                  _isMorphingMode) {
                                if (widget.currentIndex >= centerSlotIndex) {
                                  pillLeft =
                                      (widget.currentIndex + 1) * itemWidth;
                                }
                              }
                            }

                            return Stack(
                              children: [
                                if (!_isShrunk && showItems)
                                  PillIndicator(
                                    width: itemWidth,
                                    left: pillLeft,
                                  ),
                                Row(
                                  children: _buildNavItems(
                                      itemWidth, scrollValue, showItems),
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
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavItems(
      double itemWidth, double scrollValue, bool showItems) {
    final List<Widget> navWidgets = [];
    final int centerIndex = widget.items.length ~/ 2;

    if (!showItems) {
      return [_buildCenterAction(scrollValue)];
    }

    for (int i = 0; i < widget.items.length; i++) {
      if ((widget.centerAction != null ||
              widget.enableExpandableCentral ||
              _isMorphingMode) &&
          i == centerIndex) {
        navWidgets.add(
          Expanded(
            child: _buildCenterAction(scrollValue),
          ),
        );
      }

      navWidgets.add(
        Expanded(
          child: NavItemTile(
            item: widget.items[i],
            isActive: i == widget.currentIndex,
            scrollValue: scrollValue,
            onTap: () {
              if (_isExpanded) _collapse();
              widget.onTabTap?.call(i);
            },
          ),
        ),
      );
    }

    // Edge case handling for empty list or center at the end
    if ((widget.centerAction != null ||
            widget.enableExpandableCentral ||
            _isMorphingMode) &&
        navWidgets.length < 2 &&
        widget.items.isEmpty) {
      navWidgets.add(
        Expanded(
          child: _buildCenterAction(scrollValue),
        ),
      );
    } else if ((widget.centerAction != null ||
            widget.enableExpandableCentral ||
            _isMorphingMode) &&
        centerIndex == widget.items.length &&
        widget.items.isNotEmpty) {
      navWidgets.add(
        Expanded(
          child: _buildCenterAction(scrollValue),
        ),
      );
    }

    if (_isMorphingMode && _isMorphed) {
      navWidgets.add(
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.close_fullscreen_rounded, size: 20),
            color: GlassPillNavStyle.resolve(context, widget.style)
                .activeColor
                .withValues(alpha: 0.6),
            onPressed: _toggleExpand,
          ),
        ),
      );
    }

    return navWidgets;
  }

  Widget _buildCenterAction(double scrollValue) {
    final style = GlassPillNavStyle.resolve(context, widget.style);

    return Semantics(
      label: _isExpanded || _isMorphed ? 'Close actions' : 'Center action',
      button: true,
      onTap: () {
        HapticFeedback.mediumImpact();
        if (widget.enableExpandableCentral || _isMorphingMode) {
          _toggleExpand();
        } else {
          widget.onCenterActionTap?.call();
        }
      },
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          setState(() => _isCenterPressed = true);
        },
        onTapUp: (_) {
          setState(() => _isCenterPressed = false);
          HapticFeedback.mediumImpact();
          if (widget.enableExpandableCentral || _isMorphingMode) {
            _toggleExpand();
          } else {
            widget.onCenterActionTap?.call();
          }
        },
        child: GestureDetector(
          onTapDown: (_) {
            HapticFeedback.lightImpact();
            setState(() => _isCenterPressed = true);
          },
          onTapUp: (_) {
            setState(() => _isCenterPressed = false);
            HapticFeedback.mediumImpact();
            if (widget.enableExpandableCentral || _isMorphingMode) {
              _toggleExpand();
            } else {
              widget.onCenterActionTap?.call();
            }
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
              child: Center(
                child: widget.enableExpandableCentral
                    ? _buildAnimatedCenterAction(style)
                    : widget.centerAction!,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCenterAction(GlassPillNavStyle style) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _expandAnimation.value * (3.14159 / 4), // 45 degrees
          child: widget.expandedCentralAction != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: (1 - _expandAnimation.value).clamp(0.0, 1.0),
                      child: widget.centerAction ?? const GlassPillAction(),
                    ),
                    Opacity(
                      opacity: _expandAnimation.value.clamp(0.0, 1.0),
                      child: widget.expandedCentralAction!,
                    ),
                  ],
                )
              : (widget.centerAction ?? const GlassPillAction()),
        );
      },
    );
  }

  Widget _buildExpandedItems(GlassPillNavStyle style) {
    if (widget.expandableItems == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: style.baseColor
            .withValues(alpha: style.baseColor.alpha / 255.0 * 0.8),
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(style.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.blurSigma,
            sigmaY: style.blurSigma,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.expandableItems!.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(item.icon, color: style.activeColor),
                      onPressed: () {
                        item.onTap?.call();
                        _collapse();
                      },
                    ),
                    if (item.label != null)
                      Text(
                        item.label!,
                        style: TextStyle(
                          color: style.activeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
