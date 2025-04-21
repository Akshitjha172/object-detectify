import 'package:flutter/material.dart';
import 'package:object_detect/models/ml_kit_channel/ml_kit_channel.dart';

class DetectionOverlay extends StatelessWidget {
  final List<DetectionResult> results;

  const DetectionOverlay({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DetectionPainter(results),
      child: Container(),
    );
  }
}

class _DetectionPainter extends CustomPainter {
  final List<DetectionResult> results;

  _DetectionPainter(this.results);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var result in results) {
      final rect = Rect.fromLTWH(
        result.left * size.width,
        result.top * size.height,
        result.width * size.width,
        result.height * size.height,
      );
      canvas.drawRect(rect, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: result.label,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 14.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 20));
      text:
      TextSpan(
        text:
            "${result.label} ${(result.confidence * 100).toStringAsFixed(0)}%",
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
