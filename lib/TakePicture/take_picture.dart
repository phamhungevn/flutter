import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elabv01/TakePicture/TakePictureBloc/take_picture_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'TakePictureBloc/take_picture_event.dart';
import 'TakePictureBloc/take_picture_state.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({
    Key? key,
  }) : super(key: key);

  static provider() {
    return BlocProvider(
        create: (BuildContext context) {
          return TakePictureBloc();
          //..add(const TakePictureEvent.loading());
        },
        child: const TakePicture());
  }

  @override
  State<TakePicture> createState() => _TakePicture();
}

class _TakePicture extends State<TakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras = [];

  ////
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  // bool _canProcess = true;
  // bool _isBusy = false;
  //CustomPaint? _customPaint;
  // String? _text;
  ///
  @override
  void dispose() {
    //_canProcess = false;
    _faceDetector.close();
    _controller.dispose();
    super.dispose();
  }

  Future<void> onTakePicture() async {
    try {
      await _initializeControllerFuture;

      //final XFile image = await _controller.takePicture();
    } catch (e) {
      log(e.toString());
    }
  }

  void init() {
    context.read<TakePictureBloc>().add(LoadingTakePictureEvent());
  }

  Future<void> initCameras(BuildContext context) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
      //print("da khoi dong xong 1"+cameras.length.toString());
      init();
    } catch (e) {
      //  print('Error in fetching the cameras: $e');
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // final previousCameraController = _controller;
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    // Dispose the previous controller
    //  await previousCameraController?.dispose();
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ArgumentsTakePicture args =
    //     ModalRoute.of(context)?.settings.arguments as ArgumentsTakePicture;
    //final CameraDescription = cameras[1];
    initCameras(context);
    //print("da khoi dong xong 2"+cameras.length.toString());

    //onNewCameraSelected(args.camera);
    //
    return BlocBuilder<TakePictureBloc, TakePictureState>(
        builder: (BuildContext context, state) {
      onNewCameraSelected(cameras.first);
      return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Transform.rotate(
                angle: 0, //-math.pi / 2,
                child: CameraPreview(_controller),
                // CameraView(
                //   title: 'Face Detector',
                //   customPaint: _customPaint,
                //   text: _text,
                //   onImage: (inputImage) {
                //     processImage(inputImage);
                //   },
                //   initialDirection: CameraLensDirection.front,
                // )
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              if (!mounted) return;
              Navigator.of(context).pop(image.path);
            } catch (e) {
              // If an error occurs, log the error to the console.
              log(e.toString());
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
      );
    });
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
