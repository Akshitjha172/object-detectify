import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class DetectionResult {
  final double left;
  final double top;
  final double width;
  final double height;
  final String label;
  final double confidence;

  DetectionResult({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.label,
    required this.confidence,
  });

  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    return DetectionResult(
      left: map['left'],
      top: map['top'],
      width: map['width'],
      height: map['height'],
      label: map['label'],
      confidence: (map['confidence'] ?? 1.0).toDouble(), // default 1.0 if missing
    );
  }
}


class MLKitChannel {
  static const MethodChannel _channel = MethodChannel('flickit.mlkit/object_detection');

  static Future<List<DetectionResult>> processCameraImage(CameraImage image) async {
    // Convert CameraImage to a format suitable for platform channels
    // This is a placeholder; actual implementation will depend on platform requirements
    final Map<String, dynamic> imageData = {
      'width': image.width,
      'height': image.height,
      'planes': image.planes.map((plane) => plane.bytes).toList(),
    };

    final List<dynamic> results = await _channel.invokeMethod('detectObjects', imageData);
    return results.map((e) => DetectionResult.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}
