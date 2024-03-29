// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elabv01/common/widgets/button_common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../common/edit_text.dart';
import '../../common/theme.dart';
import '../../services/sign_in.dart';
import '../../services/sign_up.dart';
import '../Blocs/login_bloc.dart';
import '../Blocs/login_event.dart';
import '../Blocs/login_state.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  static provider() {
    return BlocProvider(
      create: ((context) => LoginBloc()),
      child: const MyLogin(),
    );
  }

  @override
  State<MyLogin> createState() => _MyLoginState();
}

enum LoginMethod { account, gmail, face }

class _MyLoginState extends State<MyLogin> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loading = false;

  bool signedIn = false;

  void checkLogin() {}

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    //  final GoogleSignInAccount? user = _currentUser;
    //  if (user != null) {
    if (signedIn) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // ListTile(
          //   leading: GoogleUserCircleAvatar(
          //     identity: user,
          //   ),
          //   title: Text(user.displayName ?? ''),
          //   subtitle: Text(user.email),
          // ),
          ButtonCommon(
            label: 'SIGN OUT',
            onTap: () {},
            icon: Icons.logout,
            color: Colors.white,
            padding: 10,
          ),
        ],
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ButtonCommon(
              label: 'Gmail',
              onTap: () {
                context
                    .read<LoginBloc>()
                    .add(LogginedEvent(loginMethod: LoginMethod.gmail));
              },
              icon: Icons.login,
              color: Colors.white,
              padding: 10,
            )
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    loading = false;

    return BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
      //final app = locator<FirebaseFirestore>();
      final CollectionReference usersFirebase =
          FirebaseFirestore.instance.collection('users');
      return Scaffold(
        body: StreamBuilder(
          stream: usersFirebase.snapshots(), //usersRef.snapshots(),//
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documentSnapshots =
                  snapshot.data!.docs;
              // try {
              //   List<User> userList = documentSnapshots
              //       .map((e) => User(
              //           userId: e['userId'] ?? '',
              //           user: e['user'] ?? '',
              //           password: e['password'] ?? '',
              //           email: e['email'] ?? '',
              //           modelData: jsonDecode(e['model_data']) ?? [],
              //           status: e['status'] ?? 0,
              //           updatedDate: e['updatedDate'] ?? 0,
              //           userImage: (jsonDecode(e['userImage']) as List)
              //               .map((e) => UserImage.fromMap(e))
              //               .toList()))
              //       .toList();
              //
              //   context
              //       .read<LoginBloc>()
              //       .add(LoginUpdateListEvent(userList: userList));
              // } catch (e) {
              //   log(e.toString());
              // }

            }
            return Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image(context),
                      const TextOval(
                          margin: EdgeInsets.only(top: 10),
                          label: 'Username',
                          icon: Icon(Icons.person)),
                      const TextOval(
                          margin: EdgeInsets.only(top: 10),
                          label: 'Password',
                          icon: Icon(Icons.password)),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!signedIn)
                            Flexible(
                              child: ButtonCommon(
                                  label: 'Login',
                                  onTap: () {
                                    if (!loading) {
                                      context.read<LoginBloc>().add(
                                          LogginedEvent(
                                              username: userName.text,
                                              password: password.text,
                                              loginMethod:
                                              LoginMethod.account));
                                    } else {
                                      //print("can not press");
                                    }
                                  },
                                  icon: (loading)
                                      ? Icons.not_accessible
                                      : Icons.login,
                                  color: Colors.white,
                                  padding: 10),
                            ),
                          Flexible(child: _buildBody()),
                          Flexible(
                            child: ButtonCommon(
                                label: 'Face',
                                onTap: () {
                                  if (!loading) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        const SignIn(),
                                      ),
                                    );
                                  }
                                },
                                icon: (loading)
                                    ? Icons.not_accessible
                                    : Icons.face,
                                color: Colors.white,
                                padding: 10),
                          )
                        ],
                      ),
                      const Text("Is not register?"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonCommon(
                            label: 'SignUp',
                            onTap: () {
                              if (!loading) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    const SignUp(),
                                  ),
                                );
                              }
                            },
                            icon: (loading)
                                ? Icons.not_accessible
                                : Icons.person_add,
                            color: Colors.white,
                            padding: 10,
                            backgroundColor: appTheme.primaryColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
          },
        ),
      );
    }, listener: (context, state) {
      if (state is LoggedState) {
        Navigator.pushNamed(context, '/displayPerson');
      }
      if (state is LoginStateError) {
        log("Vao day goi Display");
        const Text("Khong Vao goi Display");
      }

      // if (state is LoggedState)
      // {
      //handleSignOut();
      // }
    });
    //   BlocBuilder<LoginBloc, LoginState>(
    //   builder: (context, state) {
    //     return state.maybeMap(
    //          loaded: (state) {
    //           return const PersonDisplay();
    //          },
    //       error: (state){
    //            return ErrorPage(message: state.message.toString());
    //       },
    //       orElse: () {
    //        // handleSignOut();
    //
    //       },
    //     );
    //   },
    // );
  }
}

Widget image(BuildContext context) {
  return Image.asset(
    'images/lake.jpg',
    width: MediaQuery.of(context).size.width,
    height: 430,
    fit: BoxFit.fitWidth,
  );
}