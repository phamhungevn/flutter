import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../LoginPage/Blocs/login_bloc.dart';
import '../../repository/database_helper.dart';
import '../../LoginPage/Model/user.model.dart';
part 'student_list_event.dart';
part 'student_list_state.dart';
class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<User> studentList =[];
  LoginBloc loginBloc = LoginBloc();
  StudentListBloc() : super(const _LoadingState([])) {
    on<LoadingEvent>(loading);
    on<DeleteAllEvent>(deleteAll);
    on<StudentUpdateEvent>(update);
    on<StudentListUpdateEvent>(updateList);

  }
  Future<void> loading(LoadingEvent event, Emitter<StudentListState> emit) async {
    emit(const _LoadingState([]));
    studentList = await loginBloc.getListUser();// databaseHelper.queryAllUsers();
    //print("so luong student ${studentList.length}");
    emit(_LoadedState(studentList));
  }

  Future<void> deleteAll(DeleteAllEvent event, Emitter<StudentListState> emit) async {
    emit(const _LoadingState([]));
    await databaseHelper.deleteAll();
    studentList = await databaseHelper.queryAllUsers();
   // print("so luong student ${studentList.length}");
    emit(_LoadedState(studentList));
  }

  Future<void> update(StudentUpdateEvent event, Emitter<StudentListState> emit) async {

    User user = event.user;
    if (event.status != null){
      user.status = event.status;
    }
    await databaseHelper.update(user);
    studentList = await databaseHelper.queryAllUsers();
    emit(_LoadedState(studentList));

  }
  Future<void> updateList(StudentListUpdateEvent event, Emitter<StudentListState> emit) async {
    List<User> listUpdate=[];
    bool check;
    if (event.userList != null){
     listUpdate = event.userList!;
     for (User user in listUpdate){
       check = false;
       for (User user2 in studentList){
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
    }

    studentList = await databaseHelper.queryAllUsers();
    emit(_LoadedState(studentList));

  }

}
