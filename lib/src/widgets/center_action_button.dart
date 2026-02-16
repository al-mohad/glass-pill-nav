import 'package:flutter/material.dart';

/// A premium, glassmorphic action button matching high-end design standards.
class GlassPillAction extends StatelessWidget {
  /// The icon to display in the center of the button.
  final IconData icon;

  /// The size of the icon.
  final double iconSize;

  /// The height of the button.
  final double height;

  /// The width of the button.
  final double width;

  /// The colors for the main body gradient.
  final List<Color> bodyColors;

  /// The colors for the outer rim highlight gradient.
  final List<Color> rimColors;

  const GlassPillAction({
    super.key,
    this.icon = Icons.add,
    this.iconSize = 26,
    this.height = 38,
    this.width = 58,
    this.bodyColors = const [
      Color(0xFF0075a0), // Solid Teal
      Color(0xFFbf7a44), // Solid Orange/Copper
    ],
    this.rimColors = const [
      Color(0xFF00c2f3), // Bright teal highlight
      Color(0xFFffb076), // Bright orange highlight
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        // Outer glow/shadow
        boxShadow: [
          BoxShadow(
            color: bodyColors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(-4, 0),
          ),
          BoxShadow(
            color: bodyColors.last.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
        // The bright outer rim/highlighter
        gradient: LinearGradient(
          colors: rimColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5), // The rim thickness
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((height - 3) / 2),
          // The main body gradient
          gradient: LinearGradient(
            colors: bodyColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            // Top Gloss Sheen
            Positioned(
              top: 0,
              left: 4,
              right: 4,
              child: Container(
                height: height / 2.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(height / 2),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // The Icon
            Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
