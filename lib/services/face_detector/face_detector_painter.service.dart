import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FaceDetectorPainterService extends CustomPainter {
  final Size _absoluteImageSize;
  final Rect _faceLocation;
  final CameraLensDirection _cameraDirection;

  FaceDetectorPainterService(
      this._absoluteImageSize, this._faceLocation, this._cameraDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / _absoluteImageSize.width;
    final double scaleY = size.height / _absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    canvas.drawRect(
      Rect.fromLTRB(
        _cameraDirection == CameraLensDirection.front
            ? (_absoluteImageSize.width - _faceLocation.right) * scaleX
            : _faceLocation.left * scaleX,
        _faceLocation.top * scaleY,
        _cameraDirection == CameraLensDirection.front
            ? (_absoluteImageSize.width - _faceLocation.left) * scaleX
            : _faceLocation.right * scaleX,
        _faceLocation.bottom * scaleY,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(FaceDetectorPainterService oldDelegate) {
    return true;
  }
}
