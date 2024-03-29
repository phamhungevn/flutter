import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elabv01/TakePicture/TakePictureBloc/take_picture_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import '../common/edit_text.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/camera.service.dart';
import '../services/face_detector_service.dart';
import '../services/face_painter.dart';
import '../services/image_converter.dart';
import '../services/locator.dart';

class TakePicture2 extends StatefulWidget {
  const TakePicture2({
    Key? key,
  }) : super(key: key);

  static provider() {
    return BlocProvider(
        create: (BuildContext context) {
          return TakePictureBloc()..add(const TakePictureEvent.loaded());
        },
        child: const TakePicture2());
  }

  @override
  State<TakePicture2> createState() => _TakePicture2();
}

class _TakePicture2 extends State<TakePicture2> {
  late CameraController _controller;
  bool _isInitializing = false;
  bool processing = false;
  List<CameraDescription> cameras = [];
  Interpreter? interpreter;
  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();

  ////
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );


  @override
  void dispose() {
    //_canProcess = false;
    _faceDetector.close();

    super.dispose();
  }

  Future<void> onTakePicture() async {
    try {
      //    await _initializeControllerFuture;

      //final XFile image = await _controller.takePicture();
    } catch (e) {
      log(e.toString());
    }
  }
  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = preProcess(cameraImage, face);
    //  print("Predict 1 ${input.first}");
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    //  print("Predict 2 ${ output.first}");
    interpreter?.run(input, output);
    output = output.reshape([192]);
    print("Predict 3 ${output}");
    //_predictedData = List.from(output);
    //   print("Predict 3 Hung ${ _predictedData.first.toString()}");
  }
  Future<void> predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    interpreter = await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite');//fromAsset('assets/model.tflite');
    // interpreter.run(image!, output);
    //moi them
    _faceDetectorService.initialize();
    // await _mlService.initialize();
    // //moi them
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      //print("goi dich vu mlSerice");
      setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    // if (mounted) setState(() {});
  }
  Future<void> init() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    setState(() => _isInitializing = false);
    _cameraService.cameraController?.startImageStream((CameraImage image) async {
      if (processing)
        return; // prevents unnecessary overprocessing.
      processing = true;
      await predictFacesFromImage(image: image);
      processing = false;
    });
  }


  imglib.Image convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }
  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
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

  List preProcess(CameraImage image, Face faceDetected) {
    //sửa
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    // imglib.Image image_YUV420= convertYUV420(image);
    // imglib.Image croppedImage = _cropFace(convertYUV420(image), faceDetected);
    //
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }





  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }


  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //print("da khoi dong xong 2"+cameras.length.toString());

    //onNewCameraSelected(args.camera);
    //
    return BlocBuilder<TakePictureBloc, TakePictureState>(
      builder: (BuildContext context, state) {
        return state.maybeMap(loading: (state) {
          return const Scaffold(body: TextCommon(label: "running"));
        }, orElse: () {
          if (_isInitializing) return const Center(child: CircularProgressIndicator());
          return
            Scaffold(
            appBar: AppBar(title: const Text('Take a picture')),
            body:

                Stack(fit: StackFit.expand, children: <Widget>[
              CameraPreview(_cameraService.cameraController!),
              if (_faceDetectorService.faceDetected)
                CustomPaint(
                  painter: FacePainter(
                    face: _faceDetectorService.faces[0],
                    imageSize: _cameraService.getImageSize(),
                  ),
                )
            ],)

            ,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {

                try {
                  //await _initializeControllerFuture;

                  final image = await _controller.takePicture();
                  if (!mounted) return;
                  Navigator.of(context).pop(image.path);
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  log(e.toString());
                }
              },
              backgroundColor: Colors.red,
              child: const Text("chup"), //Icon(Icons.camera_alt),
            ),
          );
        });
      },
    );
  }
}

class Arguments {
  final int index;

  Arguments(
    this.index,
  );
}

class ArgumentsTakePicture {
  final int index;
  final CameraDescription camera;

  ArgumentsTakePicture(
    this.index,
    this.camera,
  );
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Row(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // (kIsWeb)
                //     ? Image.network(
                //   imagePath,
                //   key: ValueKey(imagePath),
                //   fit: BoxFit.fill,
                // )
                //     : Image.file(
                //   File(imagePath),
                // ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName("/editProfile"),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
