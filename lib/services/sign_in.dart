import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:elabv01/services/signin_form.dart';
import 'package:flutter/material.dart';

import '../common/widgets/auth_button.dart';
import '../common/widgets/camera_header.dart';
import '../common/widgets/single_picture.dart';
import '../LoginPage/Model/user.model.dart';
import 'camera.service.dart';
import 'camera_detection_preview.dart';
import 'face_detector_service.dart';
import 'locator.dart';
import 'ml_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final CameraService _cameraService = locator<CameraService>();
  final FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  final MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    //moi them
  //  await _mlService.initialize();
    log("Khoi dong xong");
    //
    setState(() => _isInitializing = false);
    _frameFaces();
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    //moi them
    _faceDetectorService.initialize();
    await _mlService.initialize();
    //moi them
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      //print("goi dich vu mlSerice");
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      final result = await _cameraService.takePicture();
      if( result == null){
        await _cameraService.initialize();
      }
      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(content: Text('No face detected!')));
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }
  void noUserFound(){
    showDialog(
        context: context,
        builder: (context) =>
        const AlertDialog(content: Text('No user found!')));
  }
  Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      User? user = await _mlService.predict();
      if(user != null) {
       var bottomSheetController = scaffoldKey.currentState!
          .showBottomSheet((context) => signInSheet(user: user));
      bottomSheetController.closed.whenComplete(_reload);
      } else {
        noUserFound();

       }
    }
  }

  Widget getBodyWidget() {
    if (_isInitializing) return const Center(child: CircularProgressIndicator());
    if (_isPictureTaken) {
      return SinglePicture(imagePath: _cameraService.imagePath!);
    }
    return CameraDetectionPreview();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("LOGIN", onBackPressed: _onBackPressed);
    Widget body = getBodyWidget();
    Widget? fab;
    if (!_isPictureTaken) fab = AuthButton(onTap: onTap);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

  signInSheet({@required User? user}) => user == null
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'User not found 😞',
            style: TextStyle(fontSize: 20),
          ),
        )
      : SignInSheet.provider(user:user);
}
