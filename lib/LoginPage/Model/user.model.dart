import 'dart:convert';

class User {
  String userId;
  String user;
  String password;
  String email;
  List modelData;
  List<UserImage> userImage;
  int updatedDate;
  int? level;
//  Map<int, bool>? attendanceList;
  int? status;

  User(
      {required this.userId,
      required this.user,
      required this.password,
        required this.email,
      required this.modelData,
      required this.userImage,
      required this.updatedDate,
      //   this.attendanceList,
      this.level,
      this.status});

  static User fromMap(Map<String, dynamic> user) {
   // List
    return User(
        userId: user['userId']?? '',
        user: user['user']?? "",
        password: user['password']?? "",
        email: user['email']?? "",
        modelData: jsonDecode(user['model_data'])?? "[]",
        //  attendanceList: user['attendanceList'],
        status: user['status']?? '0',
        level: user['level']?? 0,
        updatedDate: user['updatedDate']?? 0,
        userImage: (jsonDecode(user['userImage']) as List).map((e)=>UserImage.fromMap(e)).toList()
    );
  }

  toMap() {
    return {
      'userId': userId,
      'user': user,
      'password': password,
      'email': email,
      'model_data': jsonEncode(modelData),
      //'attendanceList': attendanceList,
      'status': status,
      'level': level,
      'updatedDate': updatedDate,
      'userImage': jsonEncode(userImage.map((e) => e.toMap()).toList())
    };
  }
}

class UserImage {
  String uRL;
  ImagePath source;

  UserImage({required this.uRL, required this.source});

  toMap() {
    return {
      'uRL': uRL,
      'source': source.toString(),
    };
  }

  static UserImage fromMap(Map<String, dynamic> userImage) {
    return UserImage(uRL: userImage['uRL'], source: ImagePath.values.firstWhere((element) => element.toString()==userImage['source']));
  }
}

enum ImagePath { asset, gallery, camera, network }
