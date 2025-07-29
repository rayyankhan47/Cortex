import 'package:flutter/material.dart';
import 'dart:math';

class SparkGradientBackground extends StatelessWidget {
  final Widget child;
  final bool animate;

  const SparkGradientBackground({
    super.key,
    required this.child,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8), // Very light greenish-blue
            Color(0xFFE3F2FD), // Light sky blue
            Color(0xFFE8EAF6), // Light indigo
            Color(0xFFF3E5F5), // Light purple
            Color(0xFFE0F2F1), // Light teal
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient overlay
          if (animate) _buildAnimatedOverlay(),
          // Main content
          child,
        ],
      ),
    );
  }

  Widget _buildAnimatedOverlay() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return CustomPaint(
          painter: SparkGradientPainter(value),
          size: Size.infinite,
        );
      },
    );
  }
}

class SparkGradientPainter extends CustomPainter {
  final double animationValue;

  SparkGradientPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          -0.5 + animationValue * 0.3,
          -0.3 + animationValue * 0.2,
        ),
        radius: 0.8 + animationValue * 0.4,
        colors: [
          const Color(0xFF4ECDC4).withOpacity(0.1),
          const Color(0xFF45B7D1).withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Add a second gradient for more depth
    final paint2 = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          0.3 - animationValue * 0.2,
          0.5 - animationValue * 0.3,
        ),
        radius: 0.6 + animationValue * 0.2,
        colors: [
          const Color(0xFFFF6B6B).withOpacity(0.08),
          const Color(0xFFDDA0DD).withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SparkGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const SparkGradientText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF2C3E50), // Dark blue-grey
          Color(0xFF34495E), // Lighter blue-grey
        ],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        textAlign: textAlign,
      ),
    );
  }
} 