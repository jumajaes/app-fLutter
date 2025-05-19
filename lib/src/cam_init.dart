import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/services/camera/camera.service.dart';
import 'package:kbox/services/camera/face_position_camera_message.widget.dart';
import 'package:kbox/services/face_detector/face_detector.service.dart';
import 'package:kbox/services/face_detector/face_detector_painter.service.dart';
import 'package:kbox/services/face_detector/face_recognition.service.dart';
import 'package:kbox/services/face_detector/face_rectangle.widget.dart';
import 'package:kbox/src/camera_preview.widget.dart';
import 'package:kbox/util/colors/hex_color.dart';
import 'package:kbox/util/loadings/camera_loading.widget.dart';
import 'package:kbox/util/loadings/page_loading_with_icon.widget.dart';
import 'package:kbox/util/snackbars/simple_snackbar.widget.dart';

class CamInit extends StatefulWidget {
  final bool canInit;

  const CamInit({super.key, required this.canInit});

  @override
  State<CamInit> createState() => _CamInitState();
}

class _CamInitState extends State<CamInit> {
  final CameraService _cameraService = CameraService();
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();
  late CameraController? _controller;
  bool _isCorrectFacePosition = false;
  String _displayMessage = 'Mira de frente';
  bool _isLoading = false;
  bool _isLoadingCamera = true;
  late List<double> _faceIdForCompare;

  // set _paintRectangleAroundTheFace = true for visual indication of the face location
  final bool _paintRectangleAroundTheFace = true;
  late Rect _faceLocation;
  bool _isFaceDetected = false;

  @override
  void initState() {
    super.initState();
    _launchCamera();
  }

  Future<void> _launchCamera() async {
    _controller = (await _cameraService.initializeCameraController('front'))!;

    CameraDescription frontalCamera =
        (_cameraService.getAvailableCameras())![1];
    DeviceOrientation deviceOrientation = _controller!.value.deviceOrientation;

    bool isBusy = false;
    int frameCount = 0;
    List<Face> faces = [];

    await Future.delayed(
      Duration(seconds: 1),
      () => {
        setState(() {
          _isLoadingCamera = false;
        }),
      },
    );

    _controller!.startImageStream((image) async {
      if (!isBusy) {
        isBusy = true;
        frameCount++;

        if (frameCount % CameraService.frameProcessorInterval == 0) {
          faces = await _faceDetectorService.doFaceDetectionOnFrame(
            image,
            frontalCamera,
            deviceOrientation,
          );

          print(faces.length);

          if (faces.length == 1) {
            if (_paintRectangleAroundTheFace) {
              setState(() {
                _isFaceDetected = true;
                _faceLocation = faces[0].boundingBox;
              });
            }

            if (_checkFacePosition(faces[0], 'frontal')) {
              _isCorrectFacePosition = true;
              _displayMessage = 'Perfecto';

              _faceIdForCompare = _faceRecognitionService.getFaceEmbedding(
                faces[0],
                image,
                CameraLensDirection.front,
              );
              print("embedding ok");
              setState(() {
                _isLoading = true;
              });
              await _compareWithStoredFace();
            }
          } else {
            setState(() {
              _isFaceDetected = false;
            });
          }
        }
        isBusy = false;
        setState(() {
          _isLoading = false;
          _displayMessage = 'Mira de frente';
        });
      }
    });
  }

  void _showValidationMessage(
    String message,
    HexColor backgroundColor,
    int duration,
  ) {
    SimpleSnackbarWidget.show(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      duration: 8,
    );
  }

  Future<void> _compareWithStoredFace() async {
    var embeddingFaceStore = await _faceRecognitionService
        .getEmbeddingFromAsset('assets/foto.jpg');
    print('Embedding: $embeddingFaceStore');

    double distance = _faceRecognitionService.getDistance(
      _faceIdForCompare,
      embeddingFaceStore,
    );

    print('distance: $distance');

    if (distance <= FaceRecognitionService.thresholdDistance) {
      _showValidationMessage("Perfecto, bienvenido.", ColorsApp.black, 5);
      _closeCamera();
    }
  }

  bool _checkFacePosition(Face face, String position) {
    final faceAngleX = face.headEulerAngleX ?? 0.0;
    final faceAngleY =
        Platform.isAndroid
            ? -(face.headEulerAngleY ?? 0.0)
            : (face.headEulerAngleY ??
                0.0); // Because the image is mirrored in Android
    final smileProb = face.smilingProbability ?? 0.0;
    final leftEyeOpenProb = face.leftEyeOpenProbability ?? 0.0;
    final rightEyeOpenProb = face.rightEyeOpenProbability ?? 0.0;
    bool result = false;

    switch (position) {
      case 'frontal':
        result =
            (faceAngleY >= -10 && faceAngleY <= 10) &&
            (faceAngleX >= -10 && faceAngleX <= 10);
        break;
      case 'left-profile':
        result = (faceAngleY <= -20) && (faceAngleX >= -10 && faceAngleX <= 10);
        break;
      case 'right-profile':
        result = (faceAngleY >= 20) && (faceAngleX >= -10 && faceAngleX <= 10);
        break;
      case 'smile':
        result = smileProb > 0.5;
        break;
      case 'blink':
        result = leftEyeOpenProb < 0.5 && rightEyeOpenProb < 0.5;
        break;
    }

    return result;
  }

  Future<void> _closeCamera() async {
    setState(() {
      _isFaceDetected = false;
      _isLoading = false;
    });

    keepCurrentPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingCamera ? PageLoadingWithIcon() : buildCameraPreview(),
    );
  }

  Widget buildCameraPreview() {
    List<Widget> stackChildren = [];

    stackChildren.add(
      CameraPreviewWidget(
        controller: _controller!,
        lensDirection: CameraLensDirection.front,
      ),
    );

    if (_isLoading) {
      stackChildren.add(const CameraLoadingWidget());
    }

    if (_paintRectangleAroundTheFace && _isFaceDetected) {
      stackChildren.add(FaceRectangleWidget(rectangle: buildRectangle()));
    }

    stackChildren.add(
      FacePositionCameraMessageWidget(
        isCorrectPosition: _isCorrectFacePosition,
        displayMessage: _displayMessage,
      ),
    );
    return Stack(children: stackChildren);
  }

  Widget buildRectangle() {
    final Size imageSize = Size(
      _controller!.value.previewSize!.height,
      _controller!.value.previewSize!.width,
    );

    CustomPainter faceDetectorPainter = FaceDetectorPainterService(
      imageSize,
      _faceLocation,
      CameraLensDirection.front,
    );

    return CustomPaint(painter: faceDetectorPainter);
  }

  void keepCurrentPage() {
    Navigator.of(context).popAndPushNamed("/home");
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
