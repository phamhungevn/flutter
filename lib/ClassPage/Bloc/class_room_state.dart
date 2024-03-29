import 'dart:core';

import '../class_model.dart';

class ClassRoomState {
  final int? fromDate;
  final int? toDate;

  final String? name;

  final int? numberSession;

  final int? numberHour;

  final String? faculty;
  final List<ClassModel>? classRooms;

  ClassRoomState(
      {this.classRooms,
      this.fromDate,
      this.toDate,
      this.name,
      this.numberSession,
      this.numberHour,
      this.faculty})
      : super();
}

class ClassRoomAddedState extends ClassRoomState {}

class ClassRoomLoadedState extends ClassRoomState {
  ClassRoomLoadedState({List<ClassModel>? classRooms})
      : super(classRooms: classRooms);
}

class ClassRoomErrorState extends ClassRoomState {}
