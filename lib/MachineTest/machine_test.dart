import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:elabv01/MachineTest/MachineBloc/machine_state.dart';
import 'package:elabv01/common/theme.dart';
import 'package:elabv01/common/widgets/button_common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import '../ImageClassify/image_classifiy.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/camera.service.dart';
import '../services/face_detector_service.dart';

import '../services/image_converter.dart';
import '../services/locator.dart';
import 'MachineBloc/machine_bloc.dart';
import 'MachineBloc/machine_event.dart';

class TakePicture2 extends StatefulWidget {
  const TakePicture2({
    Key? key,
  }) : super(key: key);

  static provider() {
    return BlocProvider(
        create: (BuildContext context) {
          return MachineBloc()..add(MachineEventLoading());
        },
        child: const TakePicture2());
  }

  @override
  State<TakePicture2> createState() => _TakePicture2();
}

class _TakePicture2 extends State<TakePicture2> {
  //moi
  final classifier = ImageClassifier();
  final isolateUtils = IsolateUtils();
  DetectionClasses detected = DetectionClasses.daisy;
  String nameFlower = DetectionClasses.daisy.toString();

  // het moi

 // bool _isInitializing = false;
  bool loading = true;
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

  Future<void> initialise() async {}

  Future<DetectionClasses> inference(CameraImage cameraImage) async {
    ReceivePort responsePort = ReceivePort();
    final isolateData = IsolateData(
      cameraImage: cameraImage,
      interpreterAddress: classifier.interpreter.address,
      responsePort: responsePort.sendPort,
    );

    isolateUtils.sendPort.send(isolateData);
    var result = await responsePort.first;

    return result;
  }

  @override
  void dispose() {
    //_canProcess = false;
    _faceDetector.close();
    isolateUtils.dispose();
    super.dispose();
  }

  Future<void> onTakePicture() async {
    try {
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
    if (kDebugMode) {
      print("Predict 3 $output");
    }
    //_predictedData = List.from(output);
    //   print("Predict 3 Hung ${ _predictedData.first.toString()}");
  }

  Future<void> predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    interpreter = await tfl.Interpreter.fromAsset(
        'assets/mobilefacenet.tflite'); //fromAsset('assets/model.tflite');
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

  Future<void> predictFlowerFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    if (kDebugMode) {
      print("dang du doan");
    }
    // DetectionClasses results = await classifier.predict(convertToImage(image!));
    final results = await inference(image!);
    if (kDebugMode) {
      print("da doan $results");
    }
    detected = results;
    if (detected.toString() != nameFlower) {
      setState(() {
        nameFlower = detected.toString();
      });
    }
  }

  Future<void> predictFlowerFromFile({@required imglib.Image? image}) async {
    DetectionClasses results = await classifier.predict(image!);
    detected = results;
    if (detected.toString() != nameFlower) {
      setState(() {
        nameFlower = detected.toString();
      });
    }
  }

  Future<void> init() async {
    imglib.Image? originalImage = imglib.decodeImage(File(
            "/data/user/0/com.example.elabv01/cache/CAP2264483761101635861.jpg")
        .readAsBytesSync());
    await classifier.loadModel();
    //setState(() => _isInitializing = true);
    await isolateUtils.start();
    await _cameraService.initialize();
   // setState(() => _isInitializing = false);
    if (_cameraService.cameraController != null) {
      setState(() {
        nameFlower = "khởi động";
      });
    }
    await predictFlowerFromFile(image: originalImage);
    //  _cameraService.cameraController
    //      ?.startImageStream((CameraImage image) async {
    //    if (processing) {
    //      return;
    //    }
    //    processing = true;
    // //   await predictFlowerFromImage(image: image);
    //    processing = false;
    //  });
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

  // imglib.Image _convertCameraImage(CameraImage image) {
  //   var img = convertToImage(image);
  //   var img1 = imglib.copyRotate(img, -90);
  //   return img1;
  // }

  @override
  void initState() {
    //init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MachineBloc, MachineState>(
      builder: (BuildContext context, state) {
         if (!loading){ return Scaffold(
          appBar: AppBar(title: const Text('AI Test')),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: CameraPreview(_cameraService.cameraController!),
                  ),
                  if (state.imagePath != "")
                    SizedBox(
                      height: 200,
                      child: Image.file(File(state.imagePath!)),
                    ),
                  Text(state.nameFlower!),
                  ButtonCommon(
                      label: "Import",
                      onTap: () {
                        context
                            .read<MachineBloc>()
                            .add(MachineEventUploadImage());
                      },
                      color: appTheme.primaryColor,
                      padding: 3)
                ],
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              try {
                final image =
                    await _cameraService.cameraController!.takePicture();
                if (!mounted) return;

                // Navigator.of(context).pop(image.path);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                    ),
                  ),
                );

              } catch (e) {
                // If an error occurs, log the error to the console.
                log(e.toString());
              }
            },
            backgroundColor: Colors.red,
            child: const Text("chup"), //Icon(Icons.camera_alt),
          ),
        );}
         return  const Center(
           child: CircularProgressIndicator(),
         );
        // });
      },
      listener: (BuildContext context, MachineState state) {
        if( state is LoadedMachineState){
          loading = false;
        }
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
                (kIsWeb)
                    ? Image.network(
                        imagePath,
                        key: ValueKey(imagePath),
                        fit: BoxFit.fill,
                      )
                    : Image.file(
                        File(imagePath),
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(imagePath);
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
