import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/save_local.dart';
import '../../models/profile_model.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';


class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  List<UserProfile> userProfiles =[];
  EditProfileBloc() : super( const EditProfileLoadingState([])){
    on<EditProfileLoadingEvent>(loading);
    on<EditProfileLoadedEvent>(loaded);
    on<EditProfileRotatePictureEvent>(rotatePicture);
    on<EditProfileGetUserProfilesEvent>(getUserProfiles);
  }
  void getUserProfiles(EditProfileGetUserProfilesEvent event, Emitter<EditProfileState> emit){
    emit(const EditProfileLoadingState([]));
    userProfiles = UserProfileModel().userProfile;
    //print("da vao day");
    emit(EditProfileLoadedState(userProfiles));
  }
  void loading(EditProfileLoadingEvent event, Emitter<EditProfileState> emit) {
    emit(const EditProfileLoadingState([]));
  }

  void loaded(EditProfileLoadedEvent event, Emitter<EditProfileState> emit) {

    emit(EditProfileLoadedState(userProfiles));
  }
  Future<void> rotatePicture(EditProfileRotatePictureEvent event, Emitter<EditProfileState> emit)async {
    emit(EditProfileLoadingState(userProfiles));
    String newPath = event.imagePath;
    for (int i=0; i<3;i++) {
      await Future.delayed(const Duration(seconds: 3), () async {
        SaveLocal saveLocal = SaveLocal(newPath);
        newPath = await saveLocal.rotateImage();
        userProfiles[event.userIndex].userImage[event.imageIndex].uRL =
            newPath;
      //  print("lan"+i.toString());
        emit( EditProfileLoadedState(userProfiles));
      });
    }
  }
}
