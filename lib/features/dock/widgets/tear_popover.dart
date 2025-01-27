import 'package:flutter/material.dart';

/// A custom painter that draws a teardrop-shaped background with optional borders
class TeardropPopover extends StatelessWidget {
  /// content inside the popover
  final Widget child;

  /// fill color of the popover
  final Color color;

  /// border color of the popover
  final Color borderColor;

  /// width of the border around the popover
  final double borderWidth;

  /// padding around the content inside the popover
  final EdgeInsets padding;

  /// corner radius for the rounded edges of the popover
  final double cornerRadius;

  /// Creates a [TeardropPopover] with customizable fill and border styles
  const TeardropPopover({
    super.key,
    required this.child,
    required this.color,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(8),
    this.cornerRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TeardropPainter(
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        cornerRadius: cornerRadius,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// A custom painter that draws a teardrop
class TeardropPainter extends CustomPainter {
  /// fill color for teardrop
  final Color color;

  /// border color for teardrop
  final Color borderColor;

  /// width of the border around the teardrop
  final double borderWidth;

  /// The corner radius
  final double cornerRadius;

  /// Creates a [TeardropPainter] with customizable fill and border styles
  TeardropPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path path = Path();

    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    path.lineTo(size.width, size.height - 20 - cornerRadius);
    path.quadraticBezierTo(
        size.width, size.height - 20, size.width - cornerRadius, size.height - 20);

    path.lineTo(size.width / 2 + 10, size.height - 20);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - 10, size.height - 20);

    path.lineTo(cornerRadius, size.height - 20);
    path.quadraticBezierTo(0, size.height - 20, 0, size.height - 20 - cornerRadius);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    canvas.drawPath(path, fillPaint);

    if (borderWidth > 0) {
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
