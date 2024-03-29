

import 'utils.dart';

class AppointmentModel{
  String userId;
  List<Event> listEvents;

  AppointmentModel(this.userId, this.listEvents);
  Map<String,dynamic> toJson(){
    return {
      'userId': userId,
      'listEvents': listEvents
    };
  }
}
// import 'dart:convert';
//
// class Appointment{
//   Appointment({
//     required this.date,
//     required this.dateChange,
//     required this.dateCreate,
//     required this.detail,
//     required this.duration,
//     required this.id,
//     required this.note,
//     required this.status,
//     required this.title,
//     required this.uid,
//   });
//   DateTime date;
//   DateTime dateChange;
//   DateTime dateCreate;
//   String detail;
//   int duration;
//   String id;
//   String note;
//   String status;
//   String title;
//   String uid;
//   factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
//     date: DateTime.parse(json["date"]),
//     dateChange: DateTime.parse(json["date_change"]),
//     dateCreate: DateTime.parse(json["date_create"]),
//     detail: json["detail"],
//     duration: json["duration"],
//     id: json["id"],
//     note: json["note"],
//     status: json["status"],
//     title: json["title"],
//     uid: json["uid"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "date": date.toIso8601String(),
//     "date_change": dateChange.toIso8601String(),
//     "date_create": dateCreate.toIso8601String(),
//     "detail": detail,
//     "duration": duration,
//     "id": id,
//     "note": note,
//     "status": status,
//     "title": title,
//     "uid": uid,
//   };
// }
// List<Appointment> appointmentFromJson(String str) => List<Appointment>.from(
//     json.decode(str).map((x) => Appointment.fromJson(x)));
//
// String appointmentToJson(List<Appointment> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));