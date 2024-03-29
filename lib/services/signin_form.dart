
import 'package:elabv01/LoginPage/Blocs/login_event.dart';
import 'package:elabv01/services/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../LoginPage/Blocs/login_bloc.dart';
import '../LoginPage/View/login.dart';
import '../common/widgets/app_button.dart';
import '../common/widgets/app_text_field.dart';
import '../repository/database_helper.dart';
import '../LoginPage/Model/user.model.dart';
import 'camera.service.dart';
import 'locator.dart';
class SignInSheet extends StatelessWidget {
  SignInSheet({Key? key, required this.user}) : super(key: key);
  static provider({required User user}) {
    return BlocProvider(
      create: ((context) => LoginBloc()),
      child: SignInSheet(user: user),
    );
  }
  final User user;
  final _passwordController = TextEditingController();
  final _cameraService = locator<CameraService>();

  Future _signIn(BuildContext context, User user) async {

    if (user.password == _passwordController.text) {
      user.status = 1;
   //   print("thue bao"+user.user+user.userId.toString()+user.status.toString());
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbHelper.update(user);
      context.read<LoginBloc>().add(LogginedEvent(loginMethod: LoginMethod.face,
      username: user.user,id:user.userId));
  //    print("thue bao"+user.user+user.userId.toString()+user.status.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    user.user,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Welcome back, ${user.user}.',
            style: const TextStyle(fontSize: 20),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              AppTextField(
                controller: _passwordController,
                labelText: "Password",
                isPassword: true,
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              AppButton(
                text: 'LOGIN',
                onPressed: () async {
                  _signIn(context, user);
                },
                icon: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
