import 'package:flutter/material.dart';

/// A configuration class for styling the [GlassPillNav].
class GlassPillNavStyle {
  /// The height of the navigation bar.
  final double height;

  /// Border radius of the navigation bar.
  final double borderRadius;

  /// Intensity of the glassmorphic blur.
  final double blurSigma;

  /// The base surface color of the navigation bar.
  final Color baseColor;

  /// The color for the active icon and text.
  final Color activeColor;

  /// Optional gradient background for the navigation bar.
  final Gradient? backgroundGradient;

  /// Color of the navigation bar's border.
  final Color borderColor;

  /// Width of the navigation bar's border.
  final double borderWidth;

  /// Internal padding of the navigation bar.
  final EdgeInsetsGeometry padding;

  /// Outer margin of the navigation bar.
  final EdgeInsetsGeometry margin;

  /// Duration of all animations (indicator, scale, label).
  final Duration animationDuration;

  /// Curve of all animations.
  final Curve animationCurve;

  /// Intensity of the icon scale animation.
  final double scaleAmount;

  /// Whether to enable the icon scale animation.
  final bool enableScaleAnimation;

  /// Whether to enable the shimmer effect on active icon.
  final bool enableShimmer;

  /// Whether to enable the liquid shader effect for the pill indicator.
  final bool enableLiquidEffect;

  const GlassPillNavStyle({
    this.height = 70,
    this.borderRadius = 35,
    this.blurSigma = 15,
    this.baseColor = Colors.white10,
    this.activeColor = Colors.white,
    this.backgroundGradient,
    this.borderColor = Colors.white24,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.scaleAmount = 1.1,
    this.enableScaleAnimation = true,
    this.enableShimmer = true,
    this.enableLiquidEffect = false,
  });

  /// Resolves the style using the current theme.
  static GlassPillNavStyle resolve(
      BuildContext context, GlassPillNavStyle? style) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassPillNavStyle(
      height: style?.height ?? 70,
      borderRadius: style?.borderRadius ?? 35,
      blurSigma: style?.blurSigma ?? 15,
      baseColor: style?.baseColor ??
          (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      activeColor:
          style?.activeColor ?? (isDark ? Colors.white : theme.primaryColor),
      backgroundGradient: style?.backgroundGradient,
      borderColor:
          style?.borderColor ?? (isDark ? Colors.white24 : Colors.black12),
      borderWidth: style?.borderWidth ?? 1.0,
      padding: style?.padding ?? const EdgeInsets.symmetric(horizontal: 8),
      margin: style?.margin ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      animationDuration:
          style?.animationDuration ?? const Duration(milliseconds: 300),
      animationCurve: style?.animationCurve ?? Curves.easeOutCubic,
      scaleAmount: style?.scaleAmount ?? 1.1,
      enableScaleAnimation: style?.enableScaleAnimation ?? true,
      enableShimmer: style?.enableShimmer ?? true,
      enableLiquidEffect: style?.enableLiquidEffect ?? false,
    );
  }

  GlassPillNavStyle copyWith({
    double? height,
    double? borderRadius,
    double? blurSigma,
    Color? baseColor,
    Color? activeColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Duration? animationDuration,
    Curve? animationCurve,
    double? scaleAmount,
    bool? enableScaleAnimation,
    bool? enableShimmer,
    bool? enableLiquidEffect,
  }) {
    return GlassPillNavStyle(
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      blurSigma: blurSigma ?? this.blurSigma,
      baseColor: baseColor ?? this.baseColor,
      activeColor: activeColor ?? this.activeColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      scaleAmount: scaleAmount ?? this.scaleAmount,
      enableScaleAnimation: enableScaleAnimation ?? this.enableScaleAnimation,
      enableShimmer: enableShimmer ?? this.enableShimmer,
      enableLiquidEffect: enableLiquidEffect ?? this.enableLiquidEffect,
    );
  }

  /// A premium "Nebula" preset with a deep blue active color and intense glass blur.
  /// Matches the style seen in `screenshots/standard.png`.
  static GlassPillNavStyle nebula() => const GlassPillNavStyle(
        baseColor: Colors.white10,
        activeColor: Color(0xFF40C4FF), // Bright Blue
        blurSigma: 20,
        borderRadius: 35,
        animationCurve: Curves.easeOutBack,
        scaleAmount: 1.2,
      );
}
