abstract class ClassRoomEvent {}

class RoomAddEvent extends ClassRoomEvent {
  final int fromDate;
  final int toDate;
  final String name;
  final int numberSession;
  final int numberHour;
  final String faculty;

  RoomAddEvent(
      {required this.fromDate,
      required this.toDate,
      required this.name,
      required this.numberSession,
      required this.numberHour,
      required this.faculty})
      : super();
}

class ClassRoomAllEvent extends ClassRoomEvent {
  ClassRoomAllEvent();
}
