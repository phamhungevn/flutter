
// @freezed
// class LoginStateData with _$LoginStateData {
//  const factory LoginStateData({
//   String? username,
//   String? password,
//   String? message
//  }) = _Data;
// }
// @freezed
// class LoginState with _$LoginState{
// const factory LoginState.loaded(_Data data) = _LoadedState;
// const factory LoginState.loading(_Data data) = _LoadingState;
//  }



import '../Model/user.model.dart';

class LoginState {
 List<User>? userList;
 LoginState({this.userList});
}
class LoginStateError extends LoginState{
 final String message;

 LoginStateError(this.message);

}

class LoggedState extends LoginState{
 LoggedState({required List<User> userList}):super(userList: userList);
}
//  const factory LoginState.loaded() = _LoadedState;
//  const factory LoginState.loading() = _LoadingState;
//  const factory LoginState.error(String message) = _ErrorState;
// }