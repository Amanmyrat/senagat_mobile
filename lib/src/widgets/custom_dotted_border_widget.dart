import 'package:flutter/material.dart';

class CustomDottedBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  const CustomDottedBorder({
    Key? key,
    required this.child,
    this.radius = 12,
    this.color = Colors.green,
    this.strokeWidth = 1,
    this.dashPattern = const [6, 3],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        radius: radius,
        color: color,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  _DottedBorderPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(rect);

    final dashWidth = dashPattern[0];
    final dashSpace = dashPattern[1];

    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}