import 'package:flutter/cupertino.dart';

import 'profile_model.dart';

class MatchCartModel extends ChangeNotifier {
  List<UserProfile> matchUsers = [];

  void add(UserProfile user) {
    matchUsers.add(user);
    notifyListeners();
  }

  void remove(UserProfile user) {
    matchUsers.remove(user);
    notifyListeners();
  }
  int getTotal(){
    return matchUsers.length;
  }
  UserProfile getByPosition(int index){
    return matchUsers[index];
  }
  List<UserProfile> getAllMatchUsers() {
    return matchUsers;
  }
}
