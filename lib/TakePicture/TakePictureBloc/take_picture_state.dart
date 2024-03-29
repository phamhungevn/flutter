part of 'take_picture_bloc.dart';
@freezed
class TakePictureState with _$TakePictureState{
const factory TakePictureState.loading() = _LoadingState;
const factory TakePictureState.loaded() = _LoadedState;
}