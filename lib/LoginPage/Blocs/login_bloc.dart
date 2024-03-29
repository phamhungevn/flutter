import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Endpoints/management_endpoints.dart';
import '../../repository/database_helper.dart';
import '../Model/user.model.dart';
import '../View/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<User> userList =[];
  List<User> userListUpdate =[];
  LoginBloc() : super(LoginState()) {
    on<LogginedEvent>(_sign);
    on<LogoutEvent>(_logout);
    on<LoginUpdateListEvent>(listUpdate);
  }

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );

  // GoogleSignInAccount? _currentUser;
  // bool _isAuthorized = false;
  bool isLogin = false;
  //
  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     //print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data =
  //   json.decode(response.body) as Map<String, dynamic>;
  //   final String? namedContact = _pickFirstNamedContact(data);
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //         (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final List<dynamic> names = contact['names'] as List<dynamic>;
  //     final Map<String, dynamic>? name = names.firstWhere(
  //           (dynamic name) =>
  //       (name as Map<Object?, dynamic>)['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }
  Future<GoogleSignInAccount?> gmailSign() async {
    try {

      // googleSignIn.onCurrentUserChanged
      //     .listen((GoogleSignInAccount? account) async {
      //
      //   bool isAuthorized = account != null;
      //
      //   if (kIsWeb && account != null) {
      //     isAuthorized = await googleSignIn.requestScopes(scopes);
      //   }
      //
      //   if (isAuthorized) {
      //     unawaited(_handleGetContact(account!));
      //   }
      // });
     await googleSignIn.signInSilently();
    // log("vao gay gmaill 15");
      final result = await googleSignIn.signIn();
   //  log("vao gay gmaill 16 ${result?.email!}");
      if (result != null) {
      //  log("gmail 18 ${userList.length}");
        for (User user in userList){
        //  log(user.email);
          if (user.email.toLowerCase() == result.email.toLowerCase()){
            await setPreference(
                username: result.email,
                id: user.userId,
                loginMethod: LoginMethod.gmail);
            return result;
          }

        }
        // print("ten account${result.displayName}");
        // print("ten account${result.email}");
        // print("ten account${result.id}");
        // await setPreference(
        //     username: result.email,
        //     id: result.id,
        //     loginMethod: LoginMethod.gmail);
        // return result;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }


  }
  Future<List<User>> getListUser() async {
    //userList = await databaseHelper.queryAllUsers();
    userList = await databaseHelper.queryAllAccount();
    for (User user in userList){
      print(user.user);
    }
    return userList;
  }
  String? getUserIdByEmail(String email, List<User> userList2) {
    for (User user in userList2 ){
      if (user.email.toLowerCase() == email.toLowerCase()){
        return user.userId;
      }
    }
    return null;
  }
  Future<int> registerByFace(User user)async {
    await getListUser();
    bool checkExist= false;
    for(User registeredUser in userList){
      if ((registeredUser.user == user.user)||(registeredUser.email == user.email)){
        checkExist = true;
      }
    }
    if (!checkExist){
      int result = await databaseHelper.insert(user);
      if (result !=-1){
        result = await databaseHelper.insertAccount(user);
        final CollectionReference usersFirebase =
        FirebaseFirestore.instance.collection('users');
        await usersFirebase.add(user.toMap());
        return result;
      }
    }
    return -1;

   // log("ket qua ${result2.toString()}");
  }
  String getUserEmailByUserId(String userId, List<User> userList2) {
    for (User user in userList2 ){
      if (user.userId.toLowerCase() == userId.toLowerCase()){
        return user.email;
      }
    }
    return "";
  }
  Future<void> listUpdate(LoginUpdateListEvent event, Emitter<LoginState> emit) async{
   // userList = await getListUser();
    List<User> listUpdate=[];
    bool check;
    listUpdate = event.userList;
    for (User user in listUpdate){
      check = false;
      for (User user2 in userList){
        if (user.userId == user2.userId){
          check = true;
          if (user.updatedDate > user2.updatedDate){
            log("da update${user.user}");
            await databaseHelper.update(user);
          }
          break;
        }
      }
      if (!check){
        log("da them moi${user.user}");
        await databaseHelper.insert(user);
      }
    }
    await getListUser();
    //userList = await databaseHelper.queryAllUsers();
   // log("tong so thue bao ${userList.length}");
    emit(LoginState(userList: userList));
  }
  FutureOr<void> _sign(LogginedEvent event, Emitter<LoginState> emit) async {
    // emit(const _LoadingState());
    await getListUser();
    switch (event.loginMethod) {
      case LoginMethod.account:
        {
          try {
            final response = await http.post(
              Uri.parse(ManagementEndpoint.appLogin),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'name': event.username!,
                'password': event.password!
              }),
            );
            //print(response.body);
            if (response.statusCode == 200) {
              final User user = User.fromMap(jsonDecode(response.body));
              await setPreference(
                  username: user.user,
                  id: user.userId.toString(),
                  password: event.password,
                  loginMethod: event.loginMethod);
              emit(LoggedState(userList: userList));
            } else {
              emit(LoginStateError("loi account"));
            }
          } catch (e) {
            log("loi", error: e);
            emit(LoginStateError("loi account"));
          }
        }
        break;
      case LoginMethod.gmail:
        {
          //  GoogleSignInAccount? account =
          log("Login 11");
          final result = await gmailSign();
          log("Login 12");
          // print(account?.email.toString());
          // print(account?.displayName.toString());
          // print(account?.id.toString());
          // await setPreference(
          //     username: "Phamhung",
          //     id: "123",
          //     loginMethod: event.loginMethod);
          if (result != null) {
            emit(LoggedState(userList: userList));
          } else {
            log("loi gmail");
            emit(LoginStateError("loi gmail"));
          }
        }
        break;
      default:
        //face
        await setPreference(
            username: event.username,
            id: event.id,
            loginMethod: LoginMethod.face);
   //     emit(LoggedState(userList: userList));

    }
  }

  Future<void> setPreference(
      {String? username,
      String? password,
      String? id,
      required LoginMethod loginMethod}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (loginMethod) {
      case LoginMethod.gmail:
        {
          prefs.setString('username', username!);
          prefs.setString('id', id!);
          prefs.setString('LoginMethod', loginMethod.toString());
          // log("id", name: id);
          break;
        }
      default:
        {
          prefs.setString('username', username!);
         // prefs.setString('password', password!);
          prefs.setString('id', id!);
          prefs.setString('LoginMethod', loginMethod.toString());
          break;
        }
    }
    isLogin = true;
    log("da set Preference", name: username);
  }

  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = (prefs.getString("username") != null);
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<LoginState> emit) async {
    emit(LoginState());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    googleSignIn.disconnect();
    isLogin = false;
    log("da bo Preference", name: "da bo Preference");
  }
}
