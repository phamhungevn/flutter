abstract class TimeTableEvent {}

class TimeTableEventAdd extends TimeTableEvent {
  final String? dayID;

  final String? sessionID;
  final String? subjectID;
  final String? roomID;
  final String? userID;
  final int? action;

  final List<int>? arr;

  TimeTableEventAdd(
      {required this.dayID,
      required this.sessionID,
      required this.subjectID,
      required this.roomID,
      required this.userID,
      required this.action,
      required this.arr});
}
class TimeTableEventLoading extends TimeTableEvent {}
class TimeTableClassSelectionEventLoading extends TimeTableEvent {
  String className;
  TimeTableClassSelectionEventLoading({required this.className});
}
class TimeTableImportFileEvent extends TimeTableEvent {}

