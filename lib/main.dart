import 'package:flutter/material.dart';
import 'package:object_detect/screens/camera/camera_view.dart';

void main() {
  runApp(const FlickItObjectDetector());
}

class FlickItObjectDetector extends StatelessWidget {
  const FlickItObjectDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraView(),
    );
  }
}
