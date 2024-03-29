import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

import '../LoginPage/Model/user.model.dart';
import '../repository/database_helper.dart';
import 'image_converter.dart';

class MLService {
  Interpreter? _interpreter;
  double threshold = 1; //0.5;

  List _predictedData = [];

  List get predictedData => _predictedData;

  Future initialize() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
          ),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
      //  print("interpreter kiem tra null");
         for (int i = 0;i< 5;i++) {
      _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite',
          options: interpreterOptions);
           if (_interpreter != null) {break;}
      //      else {
      // if (kDebugMode) {
      //     print("interpreter bi null lan ${i}");
      // }
      //   }
         }
    } catch (e) {
      if (kDebugMode) {
        //    print('Failed to load model.');
      }
      if (kDebugMode) {
        // log(e);
      }
    }
  }

  Future initialize2() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
          ),
        );
      }

      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
      //  print("interpreter kiem tra null");
      for (int i = 0; i < 5; i++) {
        _interpreter = await Interpreter.fromAsset(
            'assets/mobilefacenet.tflite',
            options: interpreterOptions);

        if (_interpreter != null) {
          break;
        }
        //      else {
        // if (kDebugMode) {
        //     print("interpreter bi null lan ${i}");
        // }
        //   }
      }
    } catch (e) {
      if (kDebugMode) {
        //    print('Failed to load model.');
      }
      if (kDebugMode) {
        // log(e);
      }
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);
    //  print("Predict 1 ${input.first}");
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    //  print("Predict 2 ${ output.first}");
    _interpreter?.run(input, output);
    output = output.reshape([192]);
    // print("Predict 3 ${ output}");
    _predictedData = List.from(output);
    //   print("Predict 3 Hung ${ _predictedData.first.toString()}");
  }

  Future<User?> predict() async {
    return _searchResult(_predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    //sửa
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    // imglib.Image image_YUV420= convertYUV420(image);
    // imglib.Image croppedImage = _cropFace(convertYUV420(image), faceDetected);
    //
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<User?> _searchResult(List predictedData) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    List<User> users =
        await dbHelper.queryAllAccount(); //await dbHelper.queryAllUsers();
    double minDist = 999;
    double currDist = 0.0;
    User? predictedResult;
    //   int count =0;
    for (User u in users) {
      // print("thue bao${count++}");
      //  print("du lieu${u.modelData}");
      //  print("du lieu Id${u.userId}");
      currDist = _euclideanDistance(u.modelData, predictedData);
      //print("Khoang cach$currDist");
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predictedResult = u;
        //them moi
        break;
      }
    }
    return predictedResult;
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");
    // print("kichthuoc 1 +${e1.length}");
    // print("kichthuoc 2 +${e2.length}");
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    _predictedData = value;
  }

  dispose() {}
}
