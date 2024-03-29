import 'package:elabv01/ClassPage/class_model.dart';
import 'package:elabv01/repository/database_helper.dart';
import 'package:uuid/uuid.dart';
import 'class_room_event.dart';
import 'class_room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassRoomBloc extends Bloc<ClassRoomEvent, ClassRoomState> {
  final DatabaseHelper db = DatabaseHelper.instance;
  List<ClassModel> classRooms = [];

  ClassRoomBloc() : super(ClassRoomState()) {
    on<RoomAddEvent>(addClass);
    //on<ClassRoomAllEvent>(queryAllClass);
    on<ClassRoomAllEvent>((event, emit) async {
   //   emit(ClassRoomState());
      await queryAllClass(event, emit);
     // print("goi vao 31${classRooms.length}");
      emit(ClassRoomLoadedState(classRooms: classRooms));
    });
  }

  Future<void> addClass(
      RoomAddEvent event, Emitter<ClassRoomState> emit) async {
    classRooms = await db.queryAllClassRoom();
   // bool checkClassExist = false;
    for (ClassModel classModel in classRooms){
      if (classModel.name == event.name) {
    //    checkClassExist = true;
        emit(ClassRoomErrorState());
        return;
      }
    }
    // print("vaoday 2"+event.name);
    var uuid = const Uuid();
    ClassModel classModel = ClassModel(
        id: uuid.v4(),
        fromDate: event.fromDate,
        toDate: event.toDate,
        name: event.name,
        faculty: event.faculty,
        numberHour: event.numberHour,
        numberSession: event.numberSession);
    int result = await db.insertClassRoom(classModel);
    if (result != -1) {
      emit(ClassRoomAddedState());
    } else {
      emit(ClassRoomErrorState());
    }
  }

  Future<List<ClassModel>> queryAllClass(
      ClassRoomAllEvent event, Emitter<ClassRoomState> emit) async {
    try {
      classRooms = await db.queryAllClassRoom();
      // for (ClassModel classModel in classRooms){
      //   print(classModel.name);
      // }
    //  print("vao day 2 ${classRooms.length}");
 //     emit(ClassRoomState(classRooms: classRooms));

      return classRooms;
    } catch (e) {
      return [];
    }
  }
}
