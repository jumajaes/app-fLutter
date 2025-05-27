import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  // Singleton
  static final FaceRecognitionService _instance =
      FaceRecognitionService._internal();
  // The difference between face embeddings must be <= 0.8 to consider them the same person
  static const double thresholdDistance = 0.8;
  late Interpreter _interpreter;
  static const int _width = 112;
  static const int _height = 112;

  FaceRecognitionService._internal() {
    _loadModel();
  }

  factory FaceRecognitionService() {
    return _instance;
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/ml_models/mobile_face_net.tflite');
    } catch (e) {
      throw Exception(
          'Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<double> getFaceEmbedding(
    Face face,
    CameraImage frame,
    CameraLensDirection cameraDirection,
  ) {
    late img.Image image;

    if (Platform.isAndroid) {
      image = _convertYUV420ToImage(frame);
    } else if (Platform.isIOS) {
      image = _convertBGRA8888ToImage(frame);
    }

    image = img.copyRotate(image,
        angle: cameraDirection == CameraLensDirection.front ? 270 : 90);

    Rect faceRect = face.boundingBox;

    img.Image croppedFace = img.copyCrop(image,
        x: faceRect.left.toInt(),
        y: faceRect.top.toInt(),
        width: faceRect.width.toInt(),
        height: faceRect.height.toInt());

    var input = _imageToArray(croppedFace);
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    _interpreter.run(input, output);

    List<double> outputArray = output.first.cast<double>();

    return outputArray;
  }

  double getDistance(
    List<double> embeddingCaught,
    List<double> embeddingRegistered,
  ) {
    double distance = 0;

    for (int i = 0; i < embeddingCaught.length; i++) {
      double diff = embeddingCaught[i] - embeddingRegistered[i];
      distance += diff * diff;
    }

    distance = sqrt(distance);

    return distance;
  }Future<List<double>> getEmbeddingFromAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/temp.jpg');
  await file.writeAsBytes(bytes);

  final image = img.decodeImage(bytes);
  if (image == null) throw Exception('No se pudo decodificar la imagen');

  final inputImage = InputImage.fromFile(file);
  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: false, enableLandmarks: false),
  );
  final faces = await faceDetector.processImage(inputImage);
  if (faces.isEmpty) throw Exception('No se detectó ningún rostro');

  final face = faces.first;
  final rect = face.boundingBox;

  final croppedFace = img.copyCrop(
    image,
    x: rect.left.toInt(),
    y: rect.top.toInt(),
    width: rect.width.toInt(),
    height: rect.height.toInt(),
  );

  final input = _imageToArray(croppedFace); // tu función existente
  List output = List.filled(1 * 192, 0).reshape([1, 192]);

  _interpreter.run(input, output);

  return output.first.cast<double>();
}

  img.Image _convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, _yuv2rgb(y, u, v));
      }
    }
    return image;
  }

  int _yuv2rgb(int y, int u, int v) {
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final widthCamera = cameraImage.width;
    final heightCamera = cameraImage.height;

    final image = img.Image(width: widthCamera, height: heightCamera);

    final bytes = cameraImage.planes[0].bytes;
    final bytesPerRow = cameraImage.planes[0].bytesPerRow;

    for (var h = 0; h < heightCamera; h++) {
      for (var w = 0; w < widthCamera; w++) {
        final index = (h * bytesPerRow) + (w * 4);

        if (index + 3 >= bytes.length) {
          return image;
        }

        final b = bytes[index];
        final g = bytes[index + 1];
        final r = bytes[index + 2];

        image.setPixel(w, h, image.getColor(r, g, b));
      }
    }

    return img.copyRotate(image, angle: 90);
  }

  List<dynamic> _imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: _width, height: _height);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = _height;
    int width = _width;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, _height, _width, 3]);
  }
}
