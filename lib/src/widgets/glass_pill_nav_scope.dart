import 'package:flutter/material.dart';

import '../models/glass_pill_nav_style.dart';

/// An [InheritedWidget] that provides [GlassPillNavStyle] and other state
/// to its descendants.
class GlassPillNavScope extends InheritedWidget {
  final GlassPillNavStyle style;
  final AnimationController shimmerController;

  const GlassPillNavScope({
    super.key,
    required this.style,
    required this.shimmerController,
    required super.child,
  });

  static GlassPillNavScope of(BuildContext context) {
    final GlassPillNavScope? result =
        context.dependOnInheritedWidgetOfExactType<GlassPillNavScope>();
    assert(result != null, 'No GlassPillNavScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GlassPillNavScope oldWidget) {
    return style != oldWidget.style ||
        shimmerController != oldWidget.shimmerController;
  }
}
