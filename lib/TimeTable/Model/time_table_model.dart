import 'dart:convert';
//nien che
class ClassList {
  String classId;
  List<SubjectList> subjectList;

  ClassList({required this.classId, required this.subjectList});
  toJson() {
    return {
      'classId': jsonEncode(subjectList)
    };
  }
}
class RoomList{
  String roomId;
  int maximumStudent;
  RoomList({required this.roomId, required this.maximumStudent});
  // toJson() {
  //   return {
  //     'classId': jsonEncode(subjectList)
  //   };
  // }
}
class SubjectList {
  String subjectId;
  int totalSession;
  List<SessionList> sessionList;

  SubjectList(
      {required this.subjectId,
      required this.sessionList,
      required this.totalSession});
  toJson() {
    return {
      'subjectId': subjectId,
      'totalSession': totalSession,
      'sessionList': jsonEncode(sessionList)
    };
  }
}

class SessionList {
  String roomId;
  String teacherId;
  String sessionId;
  String dateId;

  SessionList(
      {required this.roomId, required this.sessionId, required this.teacherId, required this.dateId});
}

class TaskCheck {
  String sessionId;
  String dayId;
  String teacherId;

  @override
  bool operator ==(Object other) =>
      other is TaskCheck &&
      sessionId == other.sessionId &&
      dayId == other.dayId &&
      teacherId == other.teacherId;

  @override
  int get hashCode => Object.hash(sessionId, dayId, teacherId);

  TaskCheck(
      {required this.sessionId, required this.dayId, required this.teacherId});
}
class RoomCheck {
  String sessionId;
  String dayId;
  String roomId;

  @override
  bool operator ==(Object other) =>
      other is RoomCheck &&
          sessionId == other.sessionId &&
          dayId == other.dayId &&
          roomId == other.roomId;

  @override
  int get hashCode => Object.hash(sessionId, dayId, roomId);

  RoomCheck(
      {required this.sessionId, required this.dayId, required this.roomId});
}
class ClassCheck {
  String sessionId;
  String dayId;
  String classId;

  @override
  bool operator ==(Object other) =>
      other is ClassCheck &&
          sessionId == other.sessionId &&
          dayId == other.dayId &&
          classId == other.classId;

  @override
  int get hashCode => Object.hash(sessionId, dayId, classId);

  ClassCheck(
      {required this.sessionId, required this.dayId, required this.classId});
}


// tin chi
class TimeTable {
  String userId;
  List<UserTime> listUserTime;

  TimeTable({required this.userId, required this.listUserTime});

  static TimeTable fromJson(Map<String, dynamic> timeTable) {
    return TimeTable(
        userId: timeTable['userId'],
        listUserTime: (jsonDecode(timeTable['listUserTime']) as List)
            .map((e) => UserTime.fromJson(e))
            .toList());
  }

  toJson() {
    return {
      'userId': userId,
      'listUserTime': jsonEncode(listUserTime.map((e) => e.toJson()).toList())
    };
  }
}

class UserTime {
  String subjectId;
  List<SubjectTime> listSubjectTime;

  UserTime({required this.subjectId, required this.listSubjectTime});

  static UserTime fromJson(Map<String, dynamic> userTime) {
    return UserTime(
        subjectId: userTime['subjectId'],
        listSubjectTime: (jsonDecode(userTime['listSubjectTime']) as List)
            .map((e) => SubjectTime.fromJson(e))
            .toList());
  }

  toJson() {
    return {
      'subjectId': subjectId,
      'listSubjectTime':
          jsonEncode(listSubjectTime.map((e) => e.toJson()).toList())
    };
  }
}

class SubjectTime {
  String date;
  String roomId;
  String sessionId;

  SubjectTime(
      {required this.date, required this.roomId, required this.sessionId});

  static SubjectTime fromJson(Map<String, dynamic> subjectTime) {
    return SubjectTime(
        date: subjectTime['date'],
        roomId: subjectTime['roomId'],
        sessionId: subjectTime['sessionId']);
  }

  toJson() {
    return {'date': date, 'roomId': roomId, 'sessionId': sessionId};
  }
}
