import 'dart:developer';
import 'dart:io';

import 'package:elabv01/TimeTable/Blocs/timetable_event.dart';
import 'package:elabv01/TimeTable/Blocs/timetable_state.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ClassPage/class_model.dart';
import '../../LoginPage/Blocs/login_bloc.dart';
import '../../LoginPage/Model/user.model.dart';
import '../../repository/database_helper.dart';
import '../Model/time_table_model.dart';

class TimeTableBloc extends Bloc<TimeTableEvent, TimeTableState> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  LoginBloc loginBloc = LoginBloc();
  List<ClassModel> classRooms = [];
  List<SubjectList> subjectList = [];
  List<TimeTable> timeTables = [];
  bool community = true;
  List<User> userLists = [];
  List<String> emailList = [];
  Map<RoomCheck, int> roomCheck = {};
  Map<TaskCheck, String> taskCheck = {};
  Map<ClassCheck, String> classCheck = {};
  List roomList = [];
  List sessions = ["Session 1", "Session 2", "Session 3", "Session 4"];
  List dates = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  late final SharedPreferences prefs;
  List<ClassList> listClass2 = [];
  String className = "";

  var usedSessionPerClass = List<List>.generate(
      4, (i) => List<dynamic>.generate(6, (index) => 0, growable: false),
      growable: false);

  //For fill;
  TimeTableBloc() : super(TimeTableLoadingState()) {
    on<TimeTableEventLoading>((event, emit) async {
      emit(TimeTableLoadingState());
      await loading(event, emit);
      //   print("vao day52 ${classRooms.length}");
      emit(TimeTableLoadedState(
          timeTable: timeTables,
          classRooms: classRooms,
          userList: userLists,
          emailList: emailList,
          classList: listClass2,
          classCheck: classCheck,
          className: className,
          taskCheck: taskCheck));
      // print("vao day 3${timeTables.length}");
    });
    on<TimeTableClassSelectionEventLoading>((event, emit) async {
      // emit(TimeTableLoadingState());
      className = event.className;
      //   print("vao day52 ${classRooms.length}");
      emit(TimeTableLoadedState(
          timeTable: timeTables,
          classRooms: classRooms,
          userList: userLists,
          emailList: emailList,
          classList: listClass2,
          classCheck: classCheck,
          className: className,
          taskCheck: taskCheck));
    });
    on<TimeTableImportFileEvent>((event, emit) async {
      await importFileQuestion();
      emit(TimeTableLoadedState(
          timeTable: timeTables,
          classRooms: classRooms,
          userList: userLists,
          emailList: emailList,
          classList: listClass2,
          classCheck: classCheck,
          taskCheck: taskCheck,
          className: className));
    });
    on<TimeTableEventAdd>((event, emit) async {
      //  emit(TimeTableLoadingState());
      int result = await addTimeTable(event, emit);
      if (result != -1) {
        //  print("truoc khi emit state");
        return emit(TimeTableLoadedState(
            timeTable: timeTables,
            classRooms: classRooms,
            userList: userLists,
            emailList: emailList,
            classList: listClass2,
            classCheck: classCheck,
            className: className,
            taskCheck: taskCheck));
      } else {
        emit(TimeTableErrorState());
      }
    });
  }

  bool checkClassExist(String className) {
    bool check = false;
    for (ClassModel classModel in classRooms) {
      if (classModel.name == className) {
        check = true;
        break;
      }
    }
    return check;
  }

  bool checkClassExistInCurrentList(String className) {
    bool check = false;
    for (ClassModel classModel in classRooms) {
      if (classModel.name == className) {
        check = true;
        break;
      }
    }
    return check;
  }

  bool checkRoomExistInCurrentList(String roomName) {
    bool check = false;
    for (String room in roomList) {
      if (room == roomName) {
        check = true;
        break;
      }
    }
    return check;
  }

  bool checkTeacherExistInCurrentList(String teacherName) {
    bool check = false;
    for (User user in userLists) {
      if (user.user == teacherName) {
        check = true;
        break;
      }
    }
    return check;
  }

  bool checkSubjectExist(String subjectName) {
    bool check = false;
    for (SubjectList subjectList in subjectList) {
      if (subjectList.subjectId == subjectName) {
        check = true;
        break;
      }
    }
    return check;
  }

  bool checkSubjectExistInCurrentList(String subjectName) {
    bool check = false;
    for (SubjectList subjectList in subjectList) {
      if (subjectList.subjectId == subjectName) {
        check = true;
        break;
      }
    }
    return check;
  }

  Future<void> importFileQuestion() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    File? file;
    int totalRow = 0;
    int totalSession = 0;
    String className = "";
    String subjectName = "";
    String roomName = "";
    String teacherName = "";
    ClassList classList;
    //RoomList roomList;
   // SubjectList subject;
   // List<SubjectList> subjectList = [];
    if (result != null) {
      // File
      file = File(result.files.single.path!);
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        //print(table);

     //   print(excel.tables[table]!.maxColumns);
      //  print(excel.tables[table]!.maxRows);
        for (var row in excel.tables[table]!.rows) {
          totalRow++;
          if (totalRow > 1) {
            //print("${row.map((e) => e?.value)}");
            className = row[0]!.value.toString();
            //chua có trong danh sách lớp --> chua có trong list
            if (!checkClassExist(className)) {
              classList = ClassList(classId: className, subjectList: []);
              listClass2.add(classList);
              classRooms.add(ClassModel(
                  id: totalRow.toString(),
                  fromDate: 0,
                  toDate: 0,
                  name: className,
                  faculty: "faculty",
                  numberHour: 0,
                  numberSession: 0));
            }
            int classPosition = listClass2.length - 1;
            subjectName = row[1]!.value.toString();
            roomName = row[2]!.value.toString();
            if (!checkRoomExistInCurrentList(roomName)) {
              roomList.add(roomName);
              for (int jDate = 0; jDate < 5; jDate++) {
                for (int kSession = 0; kSession < 4; kSession++) {
                  Map<RoomCheck, int> myMap = {
                    RoomCheck(
                        sessionId: sessions[kSession],
                        dayId: dates[jDate],
                        roomId: roomName): 0
                  };
                  roomCheck.addAll(myMap);
                }
              }
            }
            teacherName = row[3]!.value.toString();
            if (!checkTeacherExistInCurrentList(teacherName)) {
              userLists.add(User(
                  userId: "",
                  user: teacherName,
                  password: "password",
                  email: "email",
                  modelData: [],
                  userImage: [],
                  updatedDate: 0));
            }
            totalSession = int.parse(row[4]!.value.toString());
            subjectList = listClass2[classPosition].subjectList;
            //them vao mon mới
            if (!checkSubjectExistInCurrentList(subjectName)) {
              listClass2[classPosition].subjectList.add(SubjectList(
                    subjectId: subjectName,
                    sessionList: [],
                    totalSession: totalSession,
                  ));
            }
            int subjectPosition =
                listClass2[classPosition].subjectList.length - 1;
            for (int i = 0; i < totalSession; i++) {
              for (int jDate = 0; jDate < 5; jDate++) {
                for (int kSession = 0; kSession < 4; kSession++) {
                  //kiem tra xem phong trong, chua co nhiêm vu và chưa het session
                  //lop chua hoc phong khac
                  if (
                      //(usedSessionPerClass[kSession][jDate] == 0)
                      (classCheck[ClassCheck(
                                sessionId: sessions[kSession],
                                dayId: dates[jDate],
                                classId: className,
                              )] ==
                              null) &&
                          (roomCheck[RoomCheck(
                                sessionId: sessions[kSession],
                                dayId: dates[jDate],
                                roomId: roomName,
                              )] !=
                              1) &&
                          (taskCheck[TaskCheck(
                                sessionId: sessions[kSession],
                                dayId: dates[jDate],
                                teacherId: teacherName,
                              )] ==
                              null) &&
                          (totalSession > 0)) {
                    roomCheck[RoomCheck(
                      sessionId: sessions[kSession],
                      dayId: dates[jDate],
                      roomId: roomName,
                    )] = 1;
                    listClass2[classPosition]
                        .subjectList[subjectPosition]
                        .sessionList
                        .add(SessionList(
                            roomId: roomName,
                            sessionId: sessions[kSession],
                            teacherId: teacherName,
                            dateId: dates[jDate]));
                    taskCheck.addAll({
                      TaskCheck(
                          sessionId: sessions[kSession],
                          dayId: dates[jDate],
                          teacherId: teacherName): subjectName
                    });
                    classCheck.addAll({
                      ClassCheck(
                          sessionId: sessions[kSession],
                          dayId: dates[jDate],
                          classId: className): teacherName
                    });
                    totalSession--;

                    break;
                  }
                }
              }
            }
          }
        }
      }
    } else {
      // User canceled the picker
    }
    for (ClassList classList in listClass2) {
      log(classList.classId);
      for (SubjectList subjectList in classList.subjectList) {
        log(subjectList.subjectId);
        for (SessionList sessionList in subjectList.sessionList) {
          log(sessionList.roomId +
              sessionList.teacherId +
              sessionList.sessionId +
              sessionList.dateId);
        }
      }
    }
  }

  String getUserIdByEmail(String email) {
    String userId = loginBloc.getUserIdByEmail(email, userLists) ?? '';
    return userId;
  }

  String getUserEmailByUserId(String userId) {
    String userEmail = loginBloc.getUserEmailByUserId(userId, userLists);
    return userEmail;
  }

  Future<List<TimeTable>> loading(
      TimeTableEventLoading event, Emitter<TimeTableState> state) async {
    prefs = await SharedPreferences.getInstance();
    classRooms = await databaseHelper.queryAllClassRoom();
    //print("vao day51 ${classRoomBloc.classRooms.length}");
    timeTables = await databaseHelper.queryAllTimeTable();
    userLists = await loginBloc.getListUser();
    for (User user in userLists) {
      if ((user.email.contains("@")) && (user.email != ' ')) {
        emailList.add(user.email);
      }
    }
    for (TimeTable time in timeTables) {
      log("tai${time.toJson()}");
    }
    return timeTables;
  }

  void printAllTime() {
    // int timeTableTh=-1;
    // for (TimeTable timeTable in timeTables) {
    //   timeTableTh++;
    //   if (timeTables.elementAt(timeTableTh) != null) {
    //     print("dang tim ${timeTables[timeTableTh].toJson()}");
    //   }
    // }
  }

  Future<List<int>> checkPosition(
      String userId, String sessionId, String dateId, String subjectId) async {
    int timeTableTh = -1, userTimeTh = -1, subjectTimeTh = -1;
    List<int> arr = [];
    timeTables = await databaseHelper.queryAllTimeTable();

    for (TimeTable timeTable in timeTables) {
      timeTableTh++;

      //   print("Da tai2${timeTable.userId}");
      if (timeTable.userId == userId) {
        for (UserTime userTime in timeTable.listUserTime) {
          userTimeTh++;
          if (userTime.subjectId == subjectId) {
            for (SubjectTime subjectTime in userTime.listSubjectTime) {
              subjectTimeTh++;
              if (subjectTime.sessionId == sessionId &&
                  subjectTime.date == dateId) {
                arr.add(timeTableTh);
                arr.add(userTimeTh);
                arr.add(subjectTimeTh);
                arr.add(2);
                //print(
                //     "tim thay cập nhật $timeTableTh $userTimeTh $subjectTimeTh");
                return arr;
              }
            }
            arr.add(timeTableTh);
            arr.add(userTimeTh);
            subjectTimeTh++;
            arr.add(subjectTimeTh);
            arr.add(1);
            return arr;
            //  break;
          }
          //print(userTime.subjectId + userTime.listSubjectTime.first.sessionId);
        }
        userTimeTh++;
        arr.add(timeTableTh);
        arr.add(userTimeTh);
        arr.add(0);
        arr.add(1);
        return arr;
        //  break;
      }
    }
    timeTableTh++;
    //print("chuan bi goi mac dinh$timeTableTh");
    arr.add(timeTableTh);
    arr.add(0);
    arr.add(0);
    arr.add(1);
    return arr;
  }

  Future<int> addTimeTable(
      TimeTableEventAdd event, Emitter<TimeTableState> state) async {
    //  print(prefs.get('username'));
    // print(
    //   "tham so${"${event.arr!.elementAt(0)} ${event.arr!.elementAt(1)}${event.arr!.elementAt(2)}${event.arr!.elementAt(3)}"}");
    //print(
    // "tham so${event.sessionID.toString() + event.dayID.toString() + event.dayID.toString()}");
    int result = -1;
    // String? username = prefs.getString('username');
    List<SubjectTime> listSubjectTime = [];
    //List<UserTime> listUserTime = [];
    List<TimeTable> listTimeTable = timeTables;
    if ((event.arr?.elementAt(3) == 1) && (event.arr!.elementAt(0) >= 0)) {
      //   print("truoc khi xoa${timeTables[0].toJson()}");
      timeTables[event.arr!.elementAt(0)]
          .listUserTime[event.arr!.elementAt(1)]
          .listSubjectTime
          .removeAt(event.arr!.elementAt(2));
      if (timeTables[event.arr!.elementAt(0)]
          .listUserTime[event.arr!.elementAt(1)]
          .listSubjectTime
          .isEmpty) {
        timeTables[event.arr!.elementAt(0)]
            .listUserTime
            .removeAt(event.arr!.elementAt(1));
      }
      if (timeTables[event.arr!.elementAt(0)].listUserTime.isEmpty) {
        result = await databaseHelper.deleteAllTimeTable(
            where: "", arg: timeTables[event.arr!.elementAt(0)].userId);
      } else {
        result = await databaseHelper
            .updateTime(timeTables[event.arr!.elementAt(0)]);
      }

      timeTables = await databaseHelper.queryAllTimeTable();
      return result;
    }
    if ((event.arr!.elementAt(3) == 0) &&
        (event.arr!.elementAt(0) == -1) &&
        (event.arr!.elementAt(1) == -1) &&
        (event.arr!.elementAt(2) == -1)) {
      List<int> arr = await checkPosition(event.userID ?? "",
          event.sessionID ?? "", event.dayID ?? " ", event.subjectID ?? '');

      // print(
      //      "vi tri them${arr[0].toString() + arr[1].toString() + arr[2].toString() + arr[3].toString()}");
      bool newUser = false;
      //  String userId = await getUserIdByEmail(event.userID?? "");
      if ((arr[0] == timeTables.length)) {
        //   print("vao day 11 ${timeTables.length}"); //user lan dau co

        newUser = true;
        TimeTable timeTable =
            TimeTable(userId: event.userID ?? "", listUserTime: []);
        listTimeTable.add(timeTable);
      } else {
        //      print("vao day 12");
        listTimeTable = timeTables;
      }
      //    print("vao day 13${listTimeTable[arr[0]].toJson()}");

      if ((arr[1] == listTimeTable[arr[0]].listUserTime.length)) {
        UserTime userTime =
            UserTime(subjectId: event.subjectID!, listSubjectTime: []);
        listTimeTable[arr[0]].listUserTime.add(userTime);
      }
      // else {
      //   listSubjectTime[arr[1]]=subjectTime;
      // }
      SubjectTime subjectTime = SubjectTime(
          date: event.dayID ?? " ",
          roomId: event.roomID ?? "",
          sessionId: event.sessionID ?? "");
      if ((arr[2] ==
          listTimeTable[arr[0]].listUserTime[arr[1]].listSubjectTime.length)) {
        listTimeTable[arr[0]]
            .listUserTime[arr[1]]
            .listSubjectTime
            .add(subjectTime);
        if ((arr[0] == (listTimeTable.length - 1)) &&
            (arr[1] == 0) &&
            newUser) {
          log("vao day 15");
          result = await databaseHelper.insertTimeTable(listTimeTable[arr[0]]);
          timeTables = await databaseHelper.queryAllTimeTable();
          return result;
        } else {
          log("vao day 16");
          result = await databaseHelper.updateTime(listTimeTable[arr[0]]);
          timeTables = await databaseHelper.queryAllTimeTable();
          return result;
        }
      } else {
        listTimeTable[arr[0]].listUserTime[arr[1]].listSubjectTime[arr[2]] =
            listSubjectTime[arr[2]] = subjectTime;
        result = await databaseHelper.updateTime(listTimeTable[arr[0]]);
        timeTables = await databaseHelper.queryAllTimeTable();
        return result;
      }

      //   timeTables = await databaseHelper.queryAllTimeTable();
      //  print("sau khi them${timeTables[0].toJson()}");
      // emit(TimeTableLoadedState(timeTables));
      //  return result;
      // }
    }
    return result;
  }
}
