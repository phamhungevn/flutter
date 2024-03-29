part of 'student_list_bloc.dart';

//@freezed
class StudentListEvent {
  //const factory StudentListEvent.loading() = LoadingEvent;
 // const factory StudentListEvent.deleteAll() = DeleteAllEvent;
 // const factory StudentListEvent.update({int? status, required User user})= UpdateEvent;
}
class LoadingEvent extends StudentListEvent{}
class DeleteAllEvent extends StudentListEvent{}
class StudentUpdateEvent extends StudentListEvent{
  final int? status;
  final User user;

  StudentUpdateEvent({this.status, required this.user,}):super();
}
class StudentListUpdateEvent extends StudentListEvent{
  final List<User>? userList;
  StudentListUpdateEvent({this.userList}):super();
}
