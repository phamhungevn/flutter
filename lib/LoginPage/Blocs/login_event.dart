import '../Model/user.model.dart';
import '../View/login.dart';

abstract class LoginEvent {}

class LogginedEvent extends LoginEvent {
  final String? username;
  final String? password;

  final String? id;
  LoginMethod loginMethod;

  LogginedEvent(
      {this.username, this.password, this.id, required this.loginMethod});
}

class LoginUpdateListEvent extends LoginEvent {
  final List<User> userList;
  LoginUpdateListEvent({required this.userList});
}

class LoginEventCheck extends LoginEvent {
  LoginEventCheck();
}

class LogoutEvent extends LoginEvent {
  LogoutEvent();
}
class LoginLoadingEvent extends LoginEvent {
  LoginLoadingEvent();
}

// const factory
// LoginEvent.logout()
// =
// _LogoutEvent;const factory
// LoginEvent.checkLogin()
// =
// _CheckLoginEvent;}
