import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'take_picture_event.dart';

part 'take_picture_state.dart';

part 'take_picture_bloc.freezed.dart';

class TakePictureBloc extends Bloc<TakePictureEvent, TakePictureState> {
  TakePictureBloc() : super(const _LoadingState()) {
    on<_LoadingEvent>(loading);
    on<_LoadedEvent>(loaded);
  }

  void loading(_LoadingEvent event, Emitter<TakePictureState> emit) {
    emit(const _LoadingState());
  }

  void loaded(_LoadedEvent event, Emitter<TakePictureState> emit) {
    emit(const _LoadedState());
  }
}
