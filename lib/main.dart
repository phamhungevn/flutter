import 'package:camera/camera.dart';
import 'package:elabv01/ClassPage/class_room.dart';
import 'package:elabv01/StockPage/stock_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AppointmentPage/appointment.dart';
import 'DocumentScanner/document_scan.dart';
import 'ExamPage/exam_page.dart';
import 'ExamPage/exam_question.dart';
import 'ExcelPage/excel_example.dart';
import 'HomePage/home_page.dart';
import 'LoginPage/View/login.dart';
import 'MachineTest/machine_test.dart';
import 'MusicPage/music_page.dart';
import 'ReadPDFPage/pdf_reader.dart';
import 'SpeechToText/speech_to_text.dart';
import 'StudentList/student_list.dart';
import 'common/theme.dart';
import 'search_condition.dart';
import 'services/locator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'EditProfile/edit_profile.dart';
import 'matched_users.dart';
import 'TakePicture/take_picture.dart';
import 'TimeTable/timetable.dart';
import 'common/person_display.dart';
import 'common/error_page.dart';
import 'models/match_cart_model.dart';
import 'models/profile_model.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();

  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => UserProfileModel()),
        Provider(create: (context) => MatchCartModel()),
        ChangeNotifierProxyProvider<UserProfileModel, MatchCartModel>(
          create: (context) => MatchCartModel(),
          update: (context, userProfileModel, matchCartModel) {
            if (matchCartModel == null) throw ArgumentError.notNull('cart');
            // cart.catalog = catalog;
            return matchCartModel;
          },
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: appTheme.primaryColor,
              colorScheme: ColorScheme(
                  background: appTheme.dialogBackgroundColor,
                  brightness: Brightness.dark,
                  primary: appTheme.primaryColor,
                  onPrimary: appTheme.primaryColor,
                  secondary: appTheme.primaryColorDark,
                  onSecondary: appTheme.primaryColor,// appTheme.primaryColorDark,
                  error: appTheme.primaryColorDark,
                  onError: appTheme.primaryColorDark,
                  onBackground: appTheme.dialogBackgroundColor,
                  surface: appTheme.dialogBackgroundColor,//nền drawer
                  onSurface: Colors.grey[900]! //bieu tuong trên drawer va bottom bar
    ),
          buttonTheme: appTheme.buttonTheme,
          appBarTheme: appTheme.appBarTheme,
          textTheme: appTheme.textTheme),
          initialRoute: '/',
          routes: {
            '/': (context) => MyLogin.provider(),
            '/matchedUsers': (context) => const MatchedUsers(),
            '/searchCondition': (context) => const SearchCondition(),
            '/displayPerson': (context) => const PersonDisplay(),
            '/editProfile': (context) => EditProfile.provider(),
            '/takePicture': (context) => TakePicture.provider(),
            '/studentList': (context) => StudentList.provider(),
            '/timeTable': (context) => TimeTableClass.provider(),
            //  '/eventCalendar': (context) => TableEventsExample(),
            // '/rangeCalendar': (context) => TableRangeExample(),
            //  '/complexCalendar': (context) => const TableComplexExample(),
            '/appointment': (context) => Appointment.provider(),
            '/addClass': (context) => ClassRoom.provider(),
            '/error': (context) => const ErrorPage(
                  message: "",
                ),
            '/pdfRead': (context) => const PDFReader(),
            '/documentScanner': (context) => const DocumentScan(),
            '/speechRecord': (context) => const SpeechSampleApp(),
            '/examPage': (context) => ExamPage.provider(indexExam: ''),
            '/homePage': (context) => const HomePage(),
            '/examQuestionPage': (context) =>ExamQuestionPage.provider(),
            '/musicPage': (context) =>MusicPage.provider(),
            '/machineService': (context) =>TakePicture2.provider(),
            '/excelService': (context) =>const ExcelPage(),
            '/stockPage': (context) => StockPage.provider()
          }
          //home: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
