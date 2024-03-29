import 'package:elabv01/services/sign_in.dart';
import 'package:elabv01/services/sign_up.dart';
import 'package:flutter/material.dart';


import '../services/camera.service.dart';
import '../repository/database_helper.dart';
import '../services/face_detector_service.dart';
import '../services/locator.dart';
import '../services/ml_service.dart';

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage1> {
  final MLService _mlService = locator<MLService>();
  final FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    DatabaseHelper dataBaseHelper = DatabaseHelper.instance;
                    dataBaseHelper.deleteAll();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Image(image: AssetImage('assets/logo.png')),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Column(
                          children: [
                            Text(
                              "FACE RECOGNITION ATTENDANCE SYSTEM",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Demo application that uses Flutter and tensorflow to implement authentication with facial recognition",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const SignIn(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(color: Color(0xFF0F0BDB)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.login, color: Color(0xFF0F0BDB))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const SignUp(),
                                ),
                              );
                            //   DatabaseHelper _dataBaseHelper =
                            //       DatabaseHelper.instance;
                            // var users = await _dataBaseHelper.queryAllUsers();
                            // print(users);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF0F0BDB),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SIGN UP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.person_add, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const Divider(
                              thickness: 2,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
