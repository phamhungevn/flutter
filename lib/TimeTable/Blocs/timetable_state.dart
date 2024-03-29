import '../../ClassPage/class_model.dart';
import '../../LoginPage/Model/user.model.dart';
import '../Model/time_table_model.dart';

class TimeTableState {
  final List<TimeTable>? timeTable;
  final List<ClassModel>? classRooms;
  final List<User>? userList;
  final List<String>? emailList;
  final List<ClassList>? classList;
  Map<ClassCheck, String>? classCheck;
  Map<TaskCheck, String>? taskCheck = {};
  String? className;

  TimeTableState(
      {this.userList,
      this.timeTable,
      this.classRooms,
      this.emailList,
      this.classList,
      this.classCheck,
      this.className,
      this.taskCheck});
}

class TimeTableLoadingState extends TimeTableState {}

class TimeTableLoadedState extends TimeTableState {
  TimeTableLoadedState(
      {required List<TimeTable> timeTable,
      required List<ClassModel> classRooms,
      required List<User> userList,
      required List<String> emailList,
      required List<ClassList> classList,
      required Map<ClassCheck, String> classCheck,
      required String className,
      required Map<TaskCheck, String> taskCheck})
      : super(
            timeTable: timeTable,
            classRooms: classRooms,
            userList: userList,
            emailList: emailList,
            classList: classList,
            classCheck: classCheck,
            className: className,
            taskCheck: taskCheck);
}

class TimeTableErrorState extends TimeTableState {}
