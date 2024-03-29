

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../../LoginPage/Blocs/login_bloc.dart';
import '../../LoginPage/Model/user.model.dart';
import '../../services/camera.service.dart';
import '../../services/locator.dart';
import '../../services/ml_service.dart';
import '../../services/profile.dart';
import 'app_button.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  const AuthActionButton(
      {super.key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  AuthActionButtonState createState() => AuthActionButtonState();
}

class AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailTextEditingController =
  TextEditingController(text: '');

  User? predictedUser;

  Future _signUp(context) async {
    List predictedData = _mlService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;
    String email = _emailTextEditingController.text;
    var uuid = const Uuid();
    User userToSave = User(
      userId:uuid.v4(),
      user: user,
      password: password,
      email: email,
      modelData: predictedData,
      status: 0,
      updatedDate:  (DateTime.now().millisecondsSinceEpoch/1000).round(),
      userImage: [UserImage(uRL: _cameraService.imagePath!,source: ImagePath.gallery)],
    );
    LoginBloc loginBloc = LoginBloc();
    int result = await loginBloc.registerByFace(userToSave);
    if (result !=-1)
      {
        ToastContext().init(context);
        Toast.show("registered successfully");
      }else{
      ToastContext().init(context);
      Toast.show("register failed, account already exist!");
    }
    await Future.delayed(const Duration(milliseconds: 100));
    _mlService.setPredictedData([]);
    Navigator.pushReplacementNamed(context, '/');
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;
    if (predictedUser!.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    predictedUser!.user,
                    imagePath: _cameraService.imagePath!,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  Future<User?> _predictUser() async {
    User? userAndPass = await _mlService.predict();
    return userAndPass;
  }
 void detectedUser(){
   PersistentBottomSheetController bottomSheetController =
   Scaffold.of(context)
       .showBottomSheet((context) => signSheet(context));
   bottomSheetController.closed.whenComplete(() => widget.reload());
 }
  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          var user = await _predictUser();
          if (user != null) {
            predictedUser = user;
          }
        }
        detectedUser();
        // PersistentBottomSheetController bottomSheetController =
        //     Scaffold.of(context)
        //         .showBottomSheet((context) => signSheet(context));
        // bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
     // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Text(
                'Welcome back, ${predictedUser!.user}.',
                style: const TextStyle(fontSize: 20),
              )
              : widget.isLogin
                  ? const Text(
                  'User not found 😞',
                  style: TextStyle(fontSize: 20),
                    )
                  : Container(),
          Column(
            children: [
              !widget.isLogin
                  ? AppTextField(
                      controller: _userTextEditingController,
                      labelText: "Your Name",
                    )
                  : Container(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : AppTextField(
                      controller: _passwordTextEditingController,
                      labelText: "Password",
                      isPassword: true,
                    ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _emailTextEditingController,
                labelText: "Email",
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser != null
                  ? AppButton(
                      text: 'LOGIN',
                      onPressed: () async {
                        _signIn(context);
                      },
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                    )
                  : !widget.isLogin
                      ? AppButton(
                          text: 'SIGN UP',
                          onPressed: () async {
                            await _signUp(context);
                          },
                          icon: const Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
