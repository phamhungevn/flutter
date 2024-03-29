import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer_event.dart';
import 'drawer_state.dart';


class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  bool isLogin = false;
  late final SharedPreferences prefs;
  DrawerBloc() : super(DrawerLoadingState()) {
    on<DrawerLoadingEvent>(loading);
    on<DrawerLogoutEvent>(logout);
  }
  Future<void> loading(DrawerLoadingEvent event, Emitter<DrawerState> emit) async {
    emit(DrawerLoadingState());
    prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    isLogin = (username != null);
   // print("trang thái Drawer$isLogin");
    emit(DrawerLoadedState());
  }
  Future<void> logout(DrawerLogoutEvent event, Emitter<DrawerState> emit) async {
    isLogin = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(DrawerLogoutState());
  }
}
