import 'dart:collection';
import 'package:elabv01/repository/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../TimeTable/Model/time_table_model.dart';
import '../utils.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentBlocState> {
  DatabaseHelper db = DatabaseHelper.instance;
  List<TimeTable> timeTables = [];
  SharedPreferences? prefs;
  Map<String, List<PositionClass>> listWeekClass = {};
  final kEvents2 = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  AppointmentBloc() : super(AppointmentStateLoading()) {
    on<AppointmentEventLoading>((event, emit) async {
      await loading(event, emit);
      //print("Da goi 112");
      emit(AppointmentStateLoaded(listEvents: kEvents2));
    });
  }

  List<PositionClass> checkPosition(String dateId) {
    int timeTableTh = -1, userTimeTh = -1, subjectTimeTh = -1;
    List<PositionClass> arr = [];

    for (TimeTable timeTable in timeTables) {
      timeTableTh++;

      for (UserTime userTime in timeTable.listUserTime) {
        userTimeTh++;

        for (SubjectTime subjectTime in userTime.listSubjectTime) {
          subjectTimeTh++;
          if (subjectTime.date == dateId) {
            arr.add(PositionClass(
                timeTableTh: timeTableTh,
                userTimeTh: userTimeTh,
                subjectTimeTh: subjectTimeTh));
          }
        }
      }
    }
    return arr;
  }

  Future<void> loading(
      AppointmentEventLoading event, Emitter<AppointmentBlocState> emit) async {
    prefs = await SharedPreferences.getInstance();
    List columnHeaders = [
      "Monday",
      "Tuesday",
      "Wednesday",
      " Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    // bool isLogin = (prefs?.getString("username") != null);
    String userId = prefs?.getString("id") ?? "";
    //print("nguoi dung laf ${userId}");
    List<PositionClass>? arr = [];
    timeTables = await db.queryAllTimeTable(where: "userId=?", arg: userId);
    for (int j = 0; j < 7; j++) {
      arr = checkPosition(columnHeaders.elementAt(j));
      if (arr.isNotEmpty) {
        listWeekClass.addAll({columnHeaders.elementAt(j): arr});
      }
    }
    for (TimeTable time in timeTables) {
       //print("tai${time.toJson()}");

      int i = 0;
      int item;
      while (i <= 50) {
        //50
        item = i * 7;
        for (int j = 0; j < 7; j++) {
          arr = listWeekClass[columnHeaders.elementAt(
              DateTime(kFirstDay.year, kFirstDay.month, item + j).weekday - 1)];
          //checkPosition(columnHeaders.elementAt(
          //  DateTime(kFirstDay.year, kFirstDay.month, item + j).weekday - 1));
          // print(
          //     "Ngay${DateTime(kFirstDay.year, kFirstDay.month, item + j).weekday}");
          int k = 0;
          List<Event> events = [];
          if (arr != null) {
            for (PositionClass positionClass in arr) {
              //  print("kich thuoc ${arr.length}");
              //     "lich${positionClass.subjectTimeTh}+${positionClass.userTimeTh}+${positionClass.timeTableTh}");

              //  print("da chon");
              //  kEvents2.addAll({
              //    events = [];
              k++;
              events.add(Event(
                  '${timeTables[positionClass.timeTableTh].listUserTime[positionClass.userTimeTh].subjectId} | $k'));

              //   });
            }
            kEvents2.addAll({
              DateTime(kFirstDay.year, kFirstDay.month, item + j): events
            });
          }
        }
        i++;
      }
    }

    // int m = 0;
    // for (var event in kEvents2.keys) {
    //   print("su kien21 $m + $event");
    //   m++;
    //   for (Event event2 in kEvents2[event] ?? []) {
    //     // for (Event event in kEvents2[kEvents2.keys] ?? []){
    //     print("su kien 31 ${event2.title}");
    //   }
    // }
  }
}

class PositionClass {
  int timeTableTh = -1;
  int userTimeTh = -1;
  int subjectTimeTh = -1;

  PositionClass(
      {required this.timeTableTh,
      required this.userTimeTh,
      required this.subjectTimeTh});
}
