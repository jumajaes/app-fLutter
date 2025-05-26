import 'package:camera/camera.dart';

class CameraService {
  // Singleton
  static final CameraService _instance = CameraService._internal();
  // Process 1 of each 37 frames
  static const int frameProcessorInterval = 37;
    static const int frameProcessorIntervalAccessPoint = 37;

  List<CameraDescription>? _cameras;
  CameraController? _controller;

  CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraController? get controller => _controller;

  List<CameraDescription>? getAvailableCameras() {
    return _cameras;
  }

  Future<CameraController?> initializeCameraController(
    String cameraType,
  ) async {
    _cameras ??= await availableCameras();

    CameraDescription description =
        cameraType == 'front' ? _cameras![1] : _cameras![0];

    _controller = CameraController(description, ResolutionPreset.high);

    await _controller?.initialize();

    return _controller;
  }

  Future<void> dispose() async {
    _controller?.stopImageStream();
    _controller?.dispose();
  }
}
