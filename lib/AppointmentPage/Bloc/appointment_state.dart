import 'dart:collection';
import '../utils.dart';

class AppointmentBlocState {
  String? userId;
  LinkedHashMap<DateTime, List<Event>>? listEvents;

  AppointmentBlocState({this.userId, this.listEvents});
}

class AppointmentStateLoading extends AppointmentBlocState {
  AppointmentStateLoading() :super();
}

class AppointmentStateLoaded extends AppointmentBlocState {
  AppointmentStateLoaded({String? userId,
      LinkedHashMap<DateTime, List<Event>>? listEvents})
      :super(userId: userId, listEvents: listEvents);
}