import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera.service.dart';
import 'locator.dart';

class FaceDetectorService {
  final CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
   // _faceDetector = FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));

    _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
            performanceMode: FaceDetectorMode.accurate,
            enableContours: true,
            enableTracking: true,
            enableLandmarks: true,
            enableClassification: true));
  }

  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   // input image format from raw
  //   print(image.format.group);
  //   InputImageData _firebaseImageMetadata = InputImageData(
  //     imageRotation:
  //         _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
  //     inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ??
  //         InputImageFormat.nv21,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     planeData: image.planes.map(
  //       (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );

  //   InputImage _firebaseVisionImage = InputImage.fromBytes(
  //     bytes: image.planes[0].bytes,
  //     inputImageData: _firebaseImageMetadata,
  //   );

  //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
  // }

  //for new version

  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   InputImageData _firebaseImageMetadata = InputImageData(
  //     imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
  //     inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     planeData: image.planes.map(
  //       (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );
  //   print("Vao day 11");
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (Plane plane in image.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //
  //   final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  //
  //   InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;
  //   print("Vao day 12");
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: imageRotation,
  //     inputImageFormat: InputImageFormat.yuv420,
  //     planeData: image.planes.map(
  //           (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );
  //
  //   InputImage _firebaseVisionImage = InputImage.fromBytes(
  //     bytes: bytes,
  //     inputImageData: inputImageData,
  //   );
  //   print("Vao day 13");
  //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
  //   print("Vao day 14");
  // }
  Future<void> detectFacesFromImage(CameraImage image) async {

    InputImageData firebaseImageMetadata = InputImageData(
      imageRotation:
      _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,

      // inputImageFormat: InputImageFormat.yuv_420_888,

      inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw)
          // InputImageFormatMethods.fromRawValue(image.format.raw) for new version
          ??
          InputImageFormat.yuv_420_888,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    // for mlkit 13
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    InputImage firebaseVisionImage = InputImage.fromBytes(
      // bytes: image.planes[0].bytes,
      bytes: bytes,
      inputImageData: firebaseImageMetadata,
    );
    // for mlkit 13

    _faces = await _faceDetector.processImage(firebaseVisionImage);
  }
////dang chay
//   Future<void> detectFacesFromImage2(CameraImage image) async {
//     InputImage? _firebaseVisionImage = _processCameraImage2(image);
//     if (_firebaseVisionImage == null)
//       {
//         print("vao day 5");
//       }
//     else{
//       print("vao day 6");
//     }
//     _faces = await _faceDetector.processImage(_firebaseVisionImage!);
//   }
//   het dang chay
//   InputImage? _processCameraImage2(CameraImage image) {
//     final inputImage = _inputImageFromCameraImage(image);
//
//     print("vao day 3");
//     if (inputImage == null) return null;
//     print("vao day 4");
//     return inputImage;
//   }
//  dang chay
//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     // get camera rotation
//     final camera = _cameraService;
//     final rotation =
//     InputImageRotationValue.fromRawValue(camera.sensorOrientation);
//     print("vao day 21");
//     if (rotation == null) return null;
//     print("vao day 22");
//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     if (format == null){
//       print("vao day 25");
//     };
//     if (Platform.isAndroid && format != InputImageFormat.nv21){
//       print("vao day 26${format.toString()!}");//InputImageFormat.yuv_420_888
//     };
//     if (Platform.isIOS && format != InputImageFormat.bgra8888){
//       print("vao day 27");
//     };
//
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//        // (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isAndroid && format != InputImageFormat.yuv_420_888) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
//    print("vao day 23");
//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     //them vao day
//    // if (image.planes.length != 1) return null;
//     print("vao day 24");
//     final plane = image.planes.first;
//
//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }

  // dang chay
  dispose() {
    _faceDetector.close();
  }
}
