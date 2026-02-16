import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_pill_nav_scope.dart';

class LiquidPillIndicator extends StatefulWidget {
  final double width;
  final double left;

  const LiquidPillIndicator({
    super.key,
    required this.width,
    required this.left,
  });

  @override
  State<LiquidPillIndicator> createState() => _LiquidPillIndicatorState();
}

class _LiquidPillIndicatorState extends State<LiquidPillIndicator>
    with SingleTickerProviderStateMixin {
  FragmentProgram? _program;
  late AnimationController _timeController;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  Future<void> _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset(
        'shaders/liquid_pill.frag',
      );
      if (mounted) {
        setState(() {
          _program = program;
        });
      }
    } catch (e) {
      debugPrint('Error loading shader: $e');
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) return const SizedBox.shrink();

    final scope = GlassPillNavScope.of(context);
    final style = scope.style;

    return AnimatedPositioned(
      duration: style.animationDuration,
      curve: style.animationCurve,
      left: widget.left,
      top: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _timeController,
        builder: (context, child) {
          return CustomPaint(
            painter: LiquidPainter(
              shader: _program!.fragmentShader(),
              time: _timeController.value,
              color: style.activeColor,
              size: Size(widget.width, style.height),
              // We'll pass a normalized position for the metaball effect
              pillPos: const Offset(0.5, 0.5),
              warp: 1.0,
            ),
            size: Size(widget.width, style.height),
          );
        },
      ),
    );
  }
}

class LiquidPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final Color color;
  final Size size;
  final Offset pillPos;
  final double warp;

  LiquidPainter({
    required this.shader,
    required this.time,
    required this.color,
    required this.size,
    required this.pillPos,
    required this.warp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, time);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    shader.setFloat(3, color.red / 255.0);
    shader.setFloat(4, color.green / 255.0);
    shader.setFloat(5, color.blue / 255.0);
    shader.setFloat(6, color.alpha / 255.0);
    shader.setFloat(7, pillPos.dx);
    shader.setFloat(8, pillPos.dy);
    shader.setFloat(9, warp);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant LiquidPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.pillPos != pillPos ||
        oldDelegate.color != color;
  }
}
