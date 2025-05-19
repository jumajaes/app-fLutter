import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/services.dart';

class FaceDetectorService {
  // Singleton
  static final FaceDetectorService _instance = FaceDetectorService._internal();
  late FaceDetector _faceDetector;

  FaceDetectorService._internal() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableClassification: true,
      ),
    );
  }

  factory FaceDetectorService() {
    return _instance;
  }

  doFaceDetectionOnFrame(
    CameraImage frame,
    CameraDescription camera,
    DeviceOrientation deviceOrientation,
  ) async {
    InputImage? inputImage = _getInputImage(frame, camera, deviceOrientation);

    List<Face> faces = [];
    if (inputImage != null) {
      faces = await _faceDetector.processImage(inputImage);
      return faces;
    }
  }

  InputImage? _getInputImage(
    CameraImage frame,
    CameraDescription camera,
    DeviceOrientation deviceOrientation,
  ) {
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(
        0,
      ); // Since iOS does not mirror the front camera, it is not necessary to apply compensation
    } else if (Platform.isAndroid) {
      var rotationCompensation = orientations[deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(frame.format.raw);
    if (format == null ||
        (Platform.isAndroid &&
            format != InputImageFormat.yuv_420_888 &&
            format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (format == InputImageFormat.yuv_420_888) {
      // Transform frame yuv420888 format to nv21 format
      Uint8List nv21Bytes = _yuv420888ToNV21(frame);

      return InputImage.fromBytes(
        bytes: nv21Bytes,
        metadata: InputImageMetadata(
          size: Size(frame.width.toDouble(), frame.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: frame.width,
        ),
      );
    } else if (format == InputImageFormat.nv21 ||
        format == InputImageFormat.bgra8888) {
      final plane = frame.planes.first;

      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(frame.width.toDouble(), frame.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }

    return null;
  }

  Uint8List _yuv420888ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final ySize = width * height;
    final uvSize = width * height ~/ 4;

    final nv21 = Uint8List(ySize + uvSize * 2);

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final rowStrideY = yPlane.bytesPerRow;
    final rowStrideUV = uPlane.bytesPerRow;

    int pos = 0;

    if (rowStrideY == width) {
      nv21.setRange(0, ySize, yBuffer);
      pos += ySize;
    } else {
      int yBufferPos = -rowStrideY;
      for (; pos < ySize; pos += width) {
        yBufferPos += rowStrideY;
        nv21.setRange(
          pos,
          pos + width,
          yBuffer.sublist(yBufferPos, yBufferPos + width),
        );
      }
    }

    final pixelStride = vPlane.bytesPerPixel;

    if (pixelStride == 2 && rowStrideUV == width) {
      if (uBuffer[0] == vBuffer[1]) {
        final savePixel = vBuffer[1];
        vBuffer[1] = ~savePixel;
        if (uBuffer[0] == ~savePixel) {
          vBuffer[1] = savePixel;
          nv21.setRange(ySize, ySize + 1, vBuffer.sublist(1, 2));
          nv21.setRange(ySize + 1, ySize + 1 + uBuffer.lengthInBytes, uBuffer);
          return nv21;
        }
      }
    }

    int uvPos = ySize;
    for (int row = 0; row < height ~/ 2; row++) {
      for (int col = 0; col < width ~/ 2; col++) {
        final vuPos = col * pixelStride! + row * rowStrideUV;
        nv21[uvPos++] = vBuffer[vuPos];
        nv21[uvPos++] = uBuffer[vuPos];
      }
    }

    return nv21;
  }
}
