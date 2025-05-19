import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final CameraLensDirection lensDirection;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.lensDirection,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      height: size.height,
      child: Transform(
        alignment: Alignment.center,
        transform:
            Platform.isAndroid && lensDirection == CameraLensDirection.front
                ? Matrix4.rotationY(math.pi)
                : Matrix4.identity(),
        child: AspectRatio(
          aspectRatio: 100,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
