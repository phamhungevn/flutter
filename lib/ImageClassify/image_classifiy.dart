import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as image_lib;

enum DetectionClasses { daisy, dandelion, roses, sunflowers, tulips }

class ImageClassifier {
  /// Instance of Interpreter
  late Interpreter _interpreter;
  static const String modelFile = "assets/model.tflite";

  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
  //    for (int i = 0; i < 5; i++) {
        _interpreter = interpreter ??
            await Interpreter.fromAsset(
              modelFile,
              options: InterpreterOptions()..threads = 4,
            );

        // if (_interpreter != null) {
        //   break;
        // }
    //  }

      _interpreter.allocateTensors();
      print("chuan bi");
      print(_interpreter.getInputTensor(0).shape);
    } catch (e) {
      if (kDebugMode) {
        print("Error while creating interpreter: $e");
      }
    }
  }

  Future<DetectionClasses> predict(image_lib.Image image) async {
    image_lib.Image resizedImage =
        image_lib.copyResize(image, width: 180, height: 180);

    // Convert the resized image to a 1D Float32List.
    Float32List inputBytes = Float32List(1 * 180 * 180 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = image_lib.getRed(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = image_lib.getGreen(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = image_lib.getBlue(pixel) / 127.5 - 1.0;
      }
    }

    // Reshape to input format specific for model. 1 item in list with pixels 150x150 and 3 layers for RGB
    final input = inputBytes.reshape([1, 180, 180, 3]);

    // Output container
    final output = Float32List(1 * 5).reshape([1, 5]);
 //   final output = Float32List(1 * 4).reshape([1, 4]);

    // Run data throught model
    _interpreter.run(input, output);

    // Get index of maxumum value from outout data. Remember that models output means:
    // Index 0 - rock, 1 - paper, 2 - scissor, 3 - nothing.
    final predictionResult = output[0] as List<double>;
    if (kDebugMode) {
      print("ket qua ${predictionResult.toString()}");
    }
    double maxElement = predictionResult.reduce(
      (double maxElement, double element) =>
          element > maxElement ? element : maxElement,
    );
    return DetectionClasses.values[predictionResult.indexOf(maxElement)];
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;
}

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils.yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  SendPort responsePort;

  IsolateData({
    required this.cameraImage,
    required this.interpreterAddress,
    required this.responsePort,
  });
}

class IsolateUtils {
  static const String debugName = "InferenceIsolate";

  late Isolate _isolate;
  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: debugName,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      ImageClassifier classifier = ImageClassifier();
      // Restore interpreter from main isolate
      await classifier.loadModel(
          interpreter: Interpreter.fromAddress(isolateData.interpreterAddress));

      final convertedImage =
          ImageUtils.convertYUV420ToImage(isolateData.cameraImage);
      DetectionClasses results = await classifier.predict(convertedImage);
      isolateData.responsePort.send(results);
    }
  }

  void dispose() {
    _isolate.kill();
  }
}
