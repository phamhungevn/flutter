
import 'package:elabv01/TakePicture/TakePictureBloc/take_picture_event.dart';
import 'package:elabv01/TakePicture/TakePictureBloc/take_picture_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class TakePictureBloc extends Bloc<TakePictureEvent, TakePictureState> {
  TakePictureBloc() : super(LoadingTakePictureState()) {
    on<LoadingTakePictureEvent>(_loading);
    on<LoadedTakePictureEvent>(_loaded);
  }

  void _loading(LoadingTakePictureEvent event, Emitter<TakePictureState> emit) {
    emit(LoadingTakePictureState());
  }

  void _loaded(LoadedTakePictureEvent event, Emitter<TakePictureState> emit) {
    emit(LoadedTakePictureState());
  }
}
