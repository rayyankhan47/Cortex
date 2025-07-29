import 'dart:math';
import 'package:flutter/material.dart';

class Bubble {
  final double x;
  final double y;
  final double radius;
  final double speedX;
  final double speedY;
  final Color color;
  final double opacity;

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.opacity,
  });

  Bubble copyWith({
    double? x,
    double? y,
    double? speedX,
    double? speedY,
  }) {
    return Bubble(
      x: x ?? this.x,
      y: y ?? this.y,
      radius: radius,
      speedX: speedX ?? this.speedX,
      speedY: speedY ?? this.speedY,
      color: color,
      opacity: opacity,
    );
  }
}

class FloatingBubbles extends StatefulWidget {
  final int bubbleCount;
  final double maxRadius;
  final double minRadius;

  const FloatingBubbles({
    super.key,
    this.bubbleCount = 15,
    this.maxRadius = 60,
    this.minRadius = 20,
  });

  @override
  State<FloatingBubbles> createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<FloatingBubbles>
    with TickerProviderStateMixin {
  late List<Bubble> bubbles;
  late AnimationController _controller;
  final Random _random = Random();
  Size? _screenSize;

  final List<Color> _bubbleColors = [
    const Color(0xFFFF6B6B).withOpacity(0.3),
    const Color(0xFF4ECDC4).withOpacity(0.3),
    const Color(0xFF45B7D1).withOpacity(0.3),
    const Color(0xFF96CEB4).withOpacity(0.3),
    const Color(0xFFFFEAA7).withOpacity(0.3),
    const Color(0xFFDDA0DD).withOpacity(0.3),
    const Color(0xFF98D8C8).withOpacity(0.3),
    const Color(0xFFF7DC6F).withOpacity(0.3),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16), // 60 FPS
      vsync: this,
    );
    _controller.addListener(_updateBubbles);
    _controller.repeat();
    
    // Initialize bubbles after the first frame when we have screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeBubbles();
      }
    });
  }

  void _initializeBubbles() {
    if (_screenSize == null) return;
    
    bubbles = List.generate(widget.bubbleCount, (index) {
      return Bubble(
        x: _random.nextDouble() * _screenSize!.width,
        y: _random.nextDouble() * _screenSize!.height,
        radius: _random.nextDouble() * (widget.maxRadius - widget.minRadius) + widget.minRadius,
        speedX: (_random.nextDouble() - 0.5) * 2,
        speedY: (_random.nextDouble() - 0.5) * 2,
        color: _bubbleColors[_random.nextInt(_bubbleColors.length)],
        opacity: _random.nextDouble() * 0.4 + 0.1,
      );
    });
  }

  void _updateBubbles() {
    if (!mounted || _screenSize == null) return;

    setState(() {
      for (int i = 0; i < bubbles.length; i++) {
        final bubble = bubbles[i];
        double newX = bubble.x + bubble.speedX;
        double newY = bubble.y + bubble.speedY;
        double newSpeedX = bubble.speedX;
        double newSpeedY = bubble.speedY;

        // Bounce off walls
        if (newX - bubble.radius <= 0 || newX + bubble.radius >= _screenSize!.width) {
          newSpeedX = -newSpeedX;
          newX = newX.clamp(bubble.radius, _screenSize!.width - bubble.radius);
        }

        if (newY - bubble.radius <= 0 || newY + bubble.radius >= _screenSize!.height) {
          newSpeedY = -newSpeedY;
          newY = newY.clamp(bubble.radius, _screenSize!.height - bubble.radius);
        }

        // Add slight randomness to movement
        newSpeedX += (_random.nextDouble() - 0.5) * 0.1;
        newSpeedY += (_random.nextDouble() - 0.5) * 0.1;

        // Limit speed
        newSpeedX = newSpeedX.clamp(-3, 3);
        newSpeedY = newSpeedY.clamp(-3, 3);

        bubbles[i] = bubble.copyWith(
          x: newX,
          y: newY,
          speedX: newSpeedX,
          speedY: newSpeedY,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Update screen size when layout changes
        final newSize = Size(constraints.maxWidth, constraints.maxHeight);
        if (_screenSize != newSize) {
          _screenSize = newSize;
          // Reinitialize bubbles with new screen size
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _initializeBubbles();
            }
          });
        }
        
        return CustomPaint(
          painter: BubblePainter(bubbles),
          size: Size.infinite,
        );
      },
    );
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final paint = Paint()
        ..color = bubble.color.withOpacity(bubble.opacity)
        ..style = PaintingStyle.fill;

      // Draw main bubble
      canvas.drawCircle(
        Offset(bubble.x, bubble.y),
        bubble.radius,
        paint,
      );

      // Draw highlight for 3D effect
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity * 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubble.x - bubble.radius * 0.3, bubble.y - bubble.radius * 0.3),
        bubble.radius * 0.4,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 