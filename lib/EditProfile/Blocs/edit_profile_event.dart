class EditProfileEvent {}

class EditProfileLoadingEvent extends EditProfileEvent {}

class EditProfileLoadedEvent extends EditProfileEvent {}

class EditProfileGetUserProfilesEvent extends EditProfileEvent {}

class EditProfileRotatePictureEvent extends EditProfileEvent {
  final String imagePath;
  final int imageIndex;
  final int userIndex;
  EditProfileRotatePictureEvent(
      {required this.imagePath, required this.imageIndex, required this.userIndex});
}

