class ClassModel {
  String id;
  int fromDate;
  int toDate;
  String name;
  int numberSession;
  int numberHour;
  String faculty;

  ClassModel(
      {required this.id,
      required this.fromDate,
      required this.toDate,
      required this.name,
      required this.faculty,
      required this.numberHour,
      required this.numberSession});

  toJson() {
    return {
      'id': id,
      'fromDate': fromDate,
      'toDate': toDate,
      'name': name,
      'numberSession': numberSession,
      'numberHour': numberHour,
      'faculty': faculty
    };
  }

  static ClassModel fromJson(Map<String, dynamic> json) {
    return ClassModel(
        id: json['id'],
        fromDate: json['fromDate'],
        toDate: json['toDate'],
        name: json['name'],
        faculty: json['faculty'],
        numberHour: json['numberHour'],
        numberSession: json['numberSession']);
  }
}
