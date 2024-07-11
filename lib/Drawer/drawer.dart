import 'package:elabv01/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'DrawerBloc/drawer_bloc.dart';
import 'DrawerBloc/drawer_event.dart';
import 'DrawerBloc/drawer_state.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  static provider() {
    return BlocProvider(
      create: ((context) => DrawerBloc()..add(DrawerLoadingEvent())),
      child: const MyDrawer(),
    );
  }

  @override
  State<StatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLogin = false;
  late final SharedPreferences prefs;

  // late final SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  // Future<void> checkLogin() async {
  //   prefs = await SharedPreferences.getInstance();
  //   final int? id = prefs.getInt('id');
  //   isLogin = true; //= (id != null);
  //   print("trang thái" + isLogin.toString());
  //   setState(() {});
  // }
  Future<bool> checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    return (prefs.containsKey('username'));
  }
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    //  checkLogin();

    // TODO: implement build
    return BlocConsumer<DrawerBloc, DrawerState>(
        builder: (BuildContext context, state) {
          isLogin = context.read<DrawerBloc>().isLogin;
         // if (isLogin) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 100,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: appTheme.primaryColorDark,
                      ),
                      child: const Text('Drawer Header'),
                    ),
                  ),
                  if (isLogin)
                    ListTile(
                        title: const Text('Logout'),
                        onTap: () {
                          context.read<DrawerBloc>().add(DrawerLogoutEvent());
                          Navigator.pushReplacementNamed(context, '/');
                        })
                  else
                    ListTile(
                        title: const Text('Login'),
                        onTap: () {
                          //context.read<DrawerBloc>().add(const DrawerEvent.log());
                          Navigator.pushReplacementNamed(context, '/');
                        }),
                  ListTile(
                    title: const Text('Student list'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/studentList');
                    },
                  ),
                  ListTile(
                      title: const Text('Time Table'),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/timeTable');
                      }),
                  ListTile(
                      title: const Text('Music'),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/musicPage');
                      }),
                  ListTile(
                    title: const Text('Add Class'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/addClass');
                    },
                  ),
                  ListTile(
                    title: const Text("Appointment"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/appointment');
                    },
                  ),
                  ListTile(
                    title: const Text("PDF Reader"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/pdfRead');
                    },
                  ),
                  ListTile(
                    title: const Text("Document Scanner"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/documentScanner');
                    },
                  ),
                  ListTile(
                    title: const Text("Audio Record"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/speechRecord');
                    },
                  ),
                  ListTile(
                    title: const Text("Exam"),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/homePage');
                    },
                  ),
                  ListTile(
                    title: const Text("Add Question"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/examQuestionPage');
                    },
                  ),
                  ListTile(
                    title: const Text("AI"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/machineService');
                    },
                  ),
                  ListTile(
                    title: const Text("Excel"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/excelService');
                    },
                  ),
                  ListTile(
                    title: const Text("Stock"),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/stockPage');
                    },
                  )
                  // ListTile(
                  //   title: const Text("HomePage"),
                  //   onTap: () {
                  //     Navigator.pushReplacementNamed(
                  //         context, '/homePage');
                  //   },
                  // )
                ],
              ),
            );
          // } else {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
        },
        listener: (BuildContext context, state) {});
  }
}
