part of 'take_picture_bloc.dart';
@freezed
class TakePictureEvent with _$TakePictureEvent{
const factory TakePictureEvent.loading() = _LoadingEvent;
const factory TakePictureEvent.loaded() = _LoadedEvent;
}