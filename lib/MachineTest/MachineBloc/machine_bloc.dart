import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img_lib;
import '../../ImageClassify/image_classifiy.dart';
import '../../services/camera.service.dart';
import '../../services/locator.dart';
import 'machine_event.dart';
import 'machine_state.dart';

class MachineBloc extends Bloc<MachineEvent, MachineState> {
  MachineBloc() : super(MachineState()) {
    on<MachineEventUploadImage>((event, emit) async {
      await importImage();
      emit(LoadedMachineState(nameFlower: nameFlower, imagePath: imagePath));
    });
    on<MachineEventLoading>((event, emit) async {
      emit(LoadingMachineState());
      await init();
      emit(LoadedMachineState(nameFlower: nameFlower, imagePath: imagePath));
    });
  }

  final classifier = ImageClassifier();
  final isolateUtils = IsolateUtils();
  DetectionClasses detected = DetectionClasses.daisy;

  //bool _isInitializing = false;
  bool processing = false;
  String nameFlower = "";
  String imagePath = "";
  List<CameraDescription> cameras = [];
  Interpreter? interpreter;
  final CameraService _cameraService = locator<CameraService>();

  Future<void> init() async {
    await classifier.loadModel();
    await isolateUtils.start();
    await _cameraService.initialize();
    if (_cameraService.cameraController != null) {
      nameFlower = "khởi động xong";
    }
  }

  Future<void> importImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
    File? file;
    if (result != null) {
      try {
        file = File(result.files.single.path!);
        var bytes = File(file.path).readAsBytesSync();
        img_lib.Image? originalImage = img_lib.decodeImage(bytes);
        DetectionClasses results = await classifier.predict(originalImage!);
        if (results.toString() != nameFlower) {
          nameFlower = results.toString();
          if (kDebugMode) {
            print("anh bloc $nameFlower");
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }
}
