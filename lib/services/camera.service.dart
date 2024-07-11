
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';



class CameraService {
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  InputImageRotation? _cameraRotation;
  InputImageRotation? get cameraRotation => _cameraRotation;
  late int _sensorOrientation;
  int get sensorOrientation => _sensorOrientation;
  String? _imagePath;
  String? get imagePath => _imagePath;

  Future<void> initialize() async {
    if (_cameraController != null) return;
    CameraDescription? description = await _getCameraDescription();
  //  print("vao day 31");
    if (description != null){
      await _setupCameraController(description: description);
   //   print("vao day 32");
      _sensorOrientation = description.sensorOrientation;
      _cameraRotation = rotationIntToImageRotation(
        description.sensorOrientation,
      );
     // print("vao day 33");
    }
  }


  Future<CameraDescription?> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    int cameraIndex = -1;
    if (cameras.any(
          (element) =>
      element.lensDirection == CameraLensDirection.front &&
          element.sensorOrientation == 90,
    )) {
      cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
        element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90),
      );
    } else {
      bool kt =false;
      // for (var i = 0; i < cameras.length; i++) {
      //   if (cameras[i].lensDirection == CameraLensDirection.front) {
      //     cameraIndex = i;
      //     kt = true;
      //     break;
      //   }
      // }
      if (!kt){
        for (var i = 0; i < cameras.length; i++) {
          if (cameras[i].lensDirection == CameraLensDirection.back &&
              cameras[i].sensorOrientation == 90)  {
            cameraIndex = i;
            break;
          }
        }
      }

    }

    if (cameraIndex != -1) {
      CameraDescription camera = cameras[cameraIndex];
    //print("vao day 41");
     return camera;
    }
    return null;
  }



  Future _setupCameraController({
    required CameraDescription description,
  }) async {
    _cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420//ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    // _controller = CameraController(
    //   camera,
    //   // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
    //   ResolutionPreset.high,
    //   enableAudio: false,
    //
    // );
    await _cameraController?.initialize();
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<XFile?> takePicture() async {
    assert(_cameraController != null, 'Camera controller not initialized');
    // tu them
   // if (_cameraController == null) {
  //    log("camera bi null");
      await _cameraController?.stopImageStream();
   //   await dispose();
  //    return null;
  //  }
    // het tu them
    XFile? file = await _cameraController?.takePicture();
    _imagePath = file?.path;
    return file;
  }

  Size getImageSize() {
    assert(_cameraController != null, 'Camera controller not initialized');
    assert(
        _cameraController!.value.previewSize != null, 'Preview size is null');
    return Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );
  }

  dispose() async {
    await _cameraController?.dispose();
    _cameraController = null;
  }
}
