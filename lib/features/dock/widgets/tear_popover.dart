import 'package:flutter/material.dart';

class TeardropPopover extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double cornerRadius;

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

class TeardropPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;

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
