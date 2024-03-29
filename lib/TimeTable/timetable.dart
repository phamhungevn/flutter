import 'package:elabv01/ClassPage/Bloc/class_room_bloc.dart';
import 'package:elabv01/ClassPage/Bloc/class_room_event.dart';
import 'package:elabv01/TimeTable/Blocs/timetable_bloc.dart';
import 'package:elabv01/TimeTable/Blocs/timetable_event.dart';
import 'package:elabv01/TimeTable/Model/time_table_model.dart';
import 'package:elabv01/common/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../ClassPage/class_model.dart';
import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../LoginPage/Model/user.model.dart';
import '../common/dropdown_common.dart';
import '../common/widgets/button_common.dart';
import '../common/widgets/check_box.dart';
import '../common/widgets/dropdown_commonv2.dart';
import 'Blocs/timetable_state.dart';

class TimeTableClass extends StatelessWidget {
  const TimeTableClass({super.key});

  static provider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                ClassRoomBloc()..add(ClassRoomAllEvent())),
        BlocProvider(
            create: (BuildContext context) =>
                TimeTableBloc()..add(TimeTableEventLoading())),
      ],
      child: const TimeTableClass(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List columnHeaders = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ];
    List rowHeaders = ["Session 1", "Session 2", "Session 3", "Session 4"];
    List<String> listClasses = [];
    List<TimeTable> timeTables = [];
    List<User> userList = [];
    List<ClassList> timeTablesV2 = [];
    Map<ClassCheck, String> classCheck = {};
    Map<TaskCheck, String> taskCheck = {};
    bool credit = false;
    String className = "";

    void addClass(int i, int j, int action, List<int> arr, String teacherId,
        String classId) {
      // print(
      //     "goi event add${rowHeaders[i] + "+" + columnHeaders[j] + teacherId + classId + arr[0].toString() + arr[1].toString() + arr[2].toString() + arr[3].toString()}");
      // if (teacherId == "phamhungevn@gmail.com") {
      //   teacherId = "e22b5600-24b8-4e78-b842-7ad92ab70390";
      // }
      context.read<TimeTableBloc>().add(TimeTableEventAdd(
          dayID: columnHeaders[j],
          subjectID: classId,
          sessionID: rowHeaders[i],
          userID: teacherId,
          roomID: '102',
          action: action,
          arr: arr));
    }

    List<int> scheduleCheck(int i, int j, List<TimeTable> timeTables,
        Map<ClassCheck, String> classCheck) {
      int timeTableTh = -1, userTimeTh, subjectTimeTh = -1;
      List<int> arr = [];

      for (TimeTable timeTable in timeTables) {
        timeTableTh++;
        //   print("Da tai2${timeTable.userId}");
        userTimeTh = -1;
        for (UserTime userTime in timeTable.listUserTime) {
          userTimeTh++;
          //print(userTime.subjectId + userTime.listSubjectTime.first.sessionId);
          subjectTimeTh = -1;
          for (SubjectTime subjectTime in userTime.listSubjectTime) {
            subjectTimeTh++;
            if (subjectTime.sessionId == rowHeaders[i] &&
                subjectTime.date == columnHeaders[j]) {
              arr.add(timeTableTh);
              arr.add(userTimeTh);
              arr.add(subjectTimeTh);
              arr.add(1);
              //print("tim thay $timeTableTh $userTimeTh $subjectTimeTh");
              return arr;
            }
          }
        }
      }
      arr.add(-1); // thu tu của userId
      arr.add(-1); //thu tu mon hoc
      arr.add(-1); // thu tu buoi hoc
      arr.add(0);
      return arr;
    }

    void selectSubject(int i, int j, List<int> arr, List<String> listClasses,
        List<User> userList) {
      String teacherId = '';
      String classId = '';
      if (arr.elementAt(3) == 0) {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Tạo lớp'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownCommon(
                    items: listClasses,
                    onChanged: (String value) {
                      //print("giao vien${value}");
                      classId = value;
                    },
                    title: 'Lựa chọn môn',
                    id: const [],
                  ),
                  DropdownCommonV2(
                    items: userList,
                    //const ["Trang", "Phamhungevn@gmail.com", "Tuấn"],
                    onChanged: (User value) {
                      // if (value.toLowerCase() == "phamhungevn@gmail.com"){
                      //   teacherId = "e22b5600-24b8-4e78-b842-7ad92ab70390";
                      // }else{
                      teacherId = value.userId;
                      // }
                    },
                    title: 'Giáo viên',
                    id: const [],
                  )
                ],
              ),
              actions: [
                ButtonCommon(
                  label: 'CANCEL',
                  onTap: () {},
                  icon: Icons.cancel,
                  color: appTheme.primaryColor,
                  padding: 10,
                ),
                ButtonCommon(
                  label: 'Add',
                  onTap: () {
                    addClass(i, j, 1, arr, teacherId, classId);
                  },
                  icon: Icons.add_box_rounded,
                  color: appTheme.primaryColor,
                  padding: 10,
                ),
              ],
            );
          },
        );
      } else {
        addClass(i, j, 0, arr, teacherId, classId);
      }
    }

    List<Widget> createRows(
        {required List<TimeTable> timeTables,
        required List<String> listClasses,
        required List<User> emailList,
        required List<ClassList> timeTablesV2,
        required Map<ClassCheck, String> classCheck}) {
      List<Widget> allRows = []; //For Saving all Created Rows
      String userEmail = "";
      for (int i = 0; i < rowHeaders.length; i++) {
        List<Widget> singleRow = []; //For creating a single row
        for (int j = 0; j < columnHeaders.length; j++) {
          if (credit) {
            List<int> result = [];
            result = scheduleCheck(i, j, timeTables, classCheck);
            if (result[3] == 1) {
              userEmail = context
                  .read<TimeTableBloc>()
                  .getUserEmailByUserId(timeTables[result[0]].userId);
            }
            singleRow.add(
              Container(
                alignment: FractionalOffset.center,
                width: 120.0,
                padding: const EdgeInsets.only(
                    top: 3.0, bottom: 3.0, right: 3.0, left: 3.0),
                child: Center(
                    child: Column(
                  children: [
                    CheckboxCommon(
                      onTap: () {
                        selectSubject(i, j, result, listClasses, userList);
                      },
                      isChecked: result.elementAt(3) == 1,
                    ),
                    (result.elementAt(3) == 1)
                        ? Text(
                            userEmail) //Text(timeTables[result[0]].userId.toString())
                        : const Text(" "),
                    (result.elementAt(3) == 1)
                        ? Text(
                            "${timeTables[result[0]].listUserTime[result[1]].subjectId},${timeTables[result[0]].listUserTime[result[1]].listSubjectTime[result[2]].roomId}")
                        : const Text(" "),
                  ],
                )),
              ),
            );
          } else {
            bool result = classCheck[ClassCheck(
                    sessionId: rowHeaders[i],
                    dayId: columnHeaders[j],
                    classId: className)] !=
                null;
           String teacherName= classCheck[ClassCheck(sessionId: rowHeaders[i], dayId: columnHeaders[j], classId: className)]?? "";
           String subjectName= taskCheck[TaskCheck(sessionId: rowHeaders[i], dayId: columnHeaders[j], teacherId: teacherName)]?? "";
            //  if (classCheck[ClassCheck(sessionId:  rowHeaders[i], dayId: columnHeaders[j], classId: className)]!=null)
            {
              singleRow.add(
                Container(
                  alignment: FractionalOffset.center,
                  width: 120.0,
                  padding: const EdgeInsets.only(
                      top: 3.0, bottom: 3.0, right: 3.0, left: 3.0),
                  child: Center(
                      child: Column(
                    children: [
                      CheckboxCommon(
                        onTap: () {
                          //   selectSubject(i, j, result, listClasses, userList);
                        },
                        isChecked: result, //result.elementAt(3) == 1,
                      ),
                      (result)
                          ? Text(
                          subjectName) //Text(timeTables[result[0]].userId.toString())
                          : const Text(" "),
                      (result)
                          ? Text(
                              teacherName)
                          : const Text(" "),
                    ],
                  )),
                ),
              );
            }
          }

          //niên chế
          //hết niên chế
        }
        //Adding single Row to allRows widget
        allRows.add(Row(
          children: [
            Container(
              alignment: FractionalOffset.centerLeft,
              width: 140.0,
              padding: const EdgeInsets.only(
                  top: 3.0, bottom: 3.0, right: 3.0, left: 10.0),
              child: Text(rowHeaders[i],
                  style: TextStyle(color: Colors.grey[800])),
            ),
            ...singleRow
          ], //Add single row here
        ));
      }
      return allRows;
    }

    return BlocConsumer<TimeTableBloc, TimeTableState>(
      builder: (BuildContext context, state) {
        late final ScrollController verticalController = ScrollController();
        int rowCount = 20;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Time Table"),
            backgroundColor: appTheme.primaryColor,
          ),
          drawer: MyDrawer.provider(),
          body: OrientationBuilder(
            builder: (context, orientation) {
              return Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ButtonCommon(
                          label: 'Import Excel',
                          onTap: () {
                            context.read<TimeTableBloc>().add(
                                  TimeTableImportFileEvent(),
                                );
                          },
                          icon: Icons.upload_rounded,
                          color: appTheme.primaryColor,
                          padding: 8,
                        ),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: DropdownCommonClass(
                            items: state.classRooms ?? [],
                            onChanged: (ClassModel classModel) {
                              className = classModel.name;
                              context.read<TimeTableBloc>().add(
                                  TimeTableClassSelectionEventLoading(
                                      className: className));
                            },
                            title: 'Chọn Lớp',
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: orientation ==
                              Orientation
                                  .portrait //Handle Scroll when Orientation is changed
                          ? Axis.horizontal
                          : Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, //.center,

                        children: <Widget>[
                          Container(
                            color: Colors.blueGrey[200],
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            alignment: FractionalOffset.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: FractionalOffset.center,
                                        width: 140.0,
                                        margin: const EdgeInsets.all(0.0),
                                        padding: const EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 5.0,
                                            right: 3.0,
                                            left: 3.0),
                                        child: Text(
                                          //Leave an empty text in Row(0) and Column (0)
                                          "",
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      ...columnHeaders
                                          .map(
                                            (header) => Container(
                                              alignment:
                                                  FractionalOffset.center,
                                              width: 120.0,
                                              margin: const EdgeInsets.all(0.0),
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  right: 3.0,
                                                  left: 3.0),
                                              child: Text(
                                                header,
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                          .toList()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...createRows(
                              timeTables: timeTables,
                              listClasses: listClasses,
                              emailList: userList,
                              timeTablesV2: [],
                              classCheck: classCheck)
                        ], //Create Rows
                      ),
                    ),
                    //them mơi
                    // SizedBox(height: 300,child: TableView.builder(
                    //   verticalDetails:
                    //   ScrollableDetails.vertical(controller: verticalController),
                    //   cellBuilder: _buildCell,
                    //   columnCount: 20,
                    //   columnBuilder: _buildColumnSpan,
                    //   rowCount: rowCount,
                    //   rowBuilder: _buildRowSpan,
                    // ),)

                    //het them moi
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child:  Column(
                    //       mainAxisAlignment: MainAxisAlignment.start, //.center,
                    //
                    //       children: <Widget>[
                    //
                    //         Container(
                    //           color: Colors.blueGrey[200],
                    //           padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    //           alignment: FractionalOffset.center,
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             //center,
                    //             children: [
                    //               Container(
                    //                 margin: const EdgeInsets.all(0.0),
                    //                 child: Row(
                    //                   children: [
                    //                     Container(
                    //                       alignment: FractionalOffset.center,
                    //                       width: 140.0,
                    //                       margin: const EdgeInsets.all(0.0),
                    //                       padding: const EdgeInsets.only(
                    //                           top: 5.0,
                    //                           bottom: 5.0,
                    //                           right: 3.0,
                    //                           left: 3.0),
                    //                       child: Text(
                    //                         //Leave an empty text in Row(0) and Column (0)
                    //                         "",
                    //                         style: TextStyle(color: Colors.grey[800]),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                     ...columnHeaders
                    //                         .map(
                    //                           (header) => Container(
                    //                         alignment: FractionalOffset.center,
                    //                         width: 120.0,
                    //                         margin: const EdgeInsets.all(0.0),
                    //                         padding: const EdgeInsets.only(
                    //                             top: 5.0,
                    //                             bottom: 5.0,
                    //                             right: 3.0,
                    //                             left: 3.0),
                    //                         child: Text(
                    //                           header,
                    //                           style: TextStyle(
                    //                               color: Colors.grey[800]),
                    //                           textAlign: TextAlign.center,
                    //                         ),
                    //                       ),
                    //                     )
                    //                         .toList()
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         ...createRows(
                    //             timeTables: timeTables,
                    //             listClasses: listClasses,
                    //             emailList: userList,
                    //             timeTablesV2: [])
                    //       ], //Create Rows
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: const NavigationBottom(),
        );
      },
      listener: (BuildContext context, TimeTableState state) {
        if (state is TimeTableEventLoading) {
          //print("Trang thai loading");
          Navigator.pushNamed(context, '/displayPerson');
        }
        if (state is TimeTableLoadedState) {
          listClasses = state.classRooms!.map((e) => e.name).toList();
          timeTables = state.timeTable!;
          //emailList = state.emailList!;
          userList = state.userList!;
          timeTablesV2 = state.classList!;
          classCheck = state.classCheck!;
          className = state.className!;
          taskCheck = state.taskCheck!;
          //      print("so lơp${timeTables.length}");
        }
      },
    );
  }

  Widget _buildCell(BuildContext context, TableVicinity vicinity) {
    return Center(
      child: Text('Tile c: ${vicinity.column}, r: ${vicinity.row}'),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(),
      ),
    );

    switch (index % 5) {
      case 0:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(100),
          onEnter: (_) => {},//print('Entered column $index'),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) =>
                  t.onTap = () => {},//print('Tap column $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.5),
          onEnter: (_) => {},//print('Entered column $index'),
          cursor: SystemMouseCursors.contextMenu,
        );
      case 2:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(120),
          onEnter: (_) => {},//print('Entered column $index'),
        );
      case 3:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(145),
          onEnter: (_) => {},//print('Entered column $index'),
        );
      case 4:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(200),
          onEnter: (_) => {},//print('Entered column $index'),
        );
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }

  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index.isEven ? Colors.purple[100] : null,
      border: const TableSpanBorder(
        trailing: BorderSide(
          width: 3,
        ),
      ),
    );

    switch (index % 3) {
      case 0:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(50),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) =>
                  t.onTap = () => {},//print('Tap row $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(65),
          cursor: SystemMouseCursors.click,
        );
      case 2:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.15),
        );
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }
}
