// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// import '../services/face_detector_painter.dart';
// import 'camera_view.dart';
// import 'package:elabv01/document_scanner.dart';
//
// class FaceDetectorView extends StatefulWidget {
//   const FaceDetectorView({Key? key}) : super(key: key);
//
//   @override
//   State<FaceDetectorView> createState() => _FaceDetectorViewState();
// }
//
// class _FaceDetectorViewState extends State<FaceDetectorView> {
//
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: true,
//       enableClassification: true,
//     ),
//   );
//   bool _canProcess = true;
//   bool _isBusy = false;
//   CustomPaint? _customPaint;
//   String? _text;
//   @override
//   // Future<void> initState()  async {
//   //   WidgetsFlutterBinding.ensureInitialized();
//   //   cameras = await availableCameras();
//   //   super.initState();
//   // }
//   @override
//   void dispose() {
//     _canProcess = false;
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return CameraView(
//       title: 'Face Detector',
//       customPaint: _customPaint,
//       text: _text,
//       onImage: (inputImage) {
//         processImage(inputImage);
//       },
//       initialDirection: CameraLensDirection.front,
//     );
//   }
//
//   Future<void> processImage(InputImage inputImage) async {
//     if (!_canProcess) return;
//     if (_isBusy) return;
//     _isBusy = true;
//     setState(() {
//       _text = '';
//     });
//     print("vao day 11");
//     final faces = await _faceDetector.processImage(inputImage);
//     if (inputImage.metadata?.size != null &&
//         inputImage.metadata?.rotation != null) {
//       print("vao day 12");
//       final painter = FaceDetectorPainter(
//           faces, inputImage.metadata!.size, inputImage.metadata!.rotation);
//       _customPaint = CustomPaint(painter: painter);
//     } else {
//       print("vao day 13");
//       String text = 'Faces found: ${faces.length}\n\n';
//       for (final face in faces) {
//         text += 'face: ${face.boundingBox}\n\n';
//       }
//       _text = text;
//       // TODO: set _customPaint to draw boundingRect on top of image
//       _customPaint = null;
//     }
//     _isBusy = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
