import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'video_service.dart';
import 'camera.service.dart';
import 'face_detector_service.dart';
import 'ml_service.dart';

final GetIt locator = GetIt.instance;
bool shouldUseFirestoreEmulator = false;

Future<void> setupServices() async {
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    locator.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    if (shouldUseFirestoreEmulator) {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    }
  } catch (e) {
    log("firebase failed$e");
  }
  try {
    locator.registerLazySingleton<CameraService>(() => CameraService());
    locator
        .registerLazySingleton<FaceDetectorService>(() =>
        FaceDetectorService());
    locator.registerLazySingleton<MLService>(() => MLService());
    locator.registerLazySingleton<VideoService>(() => VideoService());
  }
  catch(e){
    log("setup service failed");
  }
}
