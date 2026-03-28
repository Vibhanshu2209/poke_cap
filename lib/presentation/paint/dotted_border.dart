import 'dart:ui';
import 'package:flutter/material.dart';

class DottedBorder extends Border {
  final double borderRadius;
  final Color color;
  final double strokeWidth;
  final double dashPattern;
  final double dashSpace;

  const DottedBorder(
      {this.borderRadius = 0.0,
      this.color = Colors.green,
      this.strokeWidth = 2.0,
      this.dashPattern = 6.0,
      this.dashSpace = 3.0});

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (this.borderRadius > 0 && shape == BoxShape.rectangle) {
      final RRect rRect =
          RRect.fromRectAndRadius(rect, Radius.circular(this.borderRadius));
      _drawDottedPath(
          canvas, Path()..addRRect(rRect), paint, dashPattern, dashSpace);
    } else if (shape == BoxShape.rectangle) {
      final Path path = Path()..addRect(rect);
      _drawDottedPath(canvas, path, paint, dashPattern, dashSpace);
    } else if (shape == BoxShape.circle) {
      final Path path = Path()..addOval(rect);
      _drawDottedPath(canvas, path, paint, dashPattern, dashSpace);
    }
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint, double dashWidth,
      double dashSpace) {
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double currentDistance = 0.0;
      while (currentDistance < pathMetric.length) {
        double nextDistance = currentDistance + dashWidth;
        if (nextDistance > pathMetric.length) {
          nextDistance = pathMetric.length;
        }
        Tangent? startTangent = pathMetric.getTangentForOffset(currentDistance);
        Tangent? endTangent = pathMetric.getTangentForOffset(nextDistance);
        if (startTangent != null && endTangent != null) {
          canvas.drawLine(startTangent.position, endTangent.position, paint);
        }
        currentDistance += dashWidth + dashSpace;
      }
    }
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  bool get isUniform => true;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(RRect.fromRectAndRadius(
        rect.deflate(dimensions.resolve(textDirection).top),
        Radius.circular(borderRadius)));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
}
