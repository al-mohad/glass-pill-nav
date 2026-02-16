import 'package:flutter/material.dart';

/// A model representing an item in the [GlassPillNav].
class GlassPillNavItem {
  /// The icon to play for this item.
  final IconData icon;

  /// Optional text label to display below the icon.
  final String? label;

  /// Optional callback when this item is tapped.
  final VoidCallback? onTap;

  const GlassPillNavItem({
    required this.icon,
    this.label,
    this.onTap,
  });
}
