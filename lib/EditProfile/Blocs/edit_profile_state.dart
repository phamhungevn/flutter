
// @freezed
// class EditProfileStateData with _$EditProfileStateData {
//   const factory EditProfileStateData({
//     required List<UserProfile> listUserProfiles
//   }) = Data;
// }

// @freezed
// class EditProfileState with _$EditProfileState{
//  factory EditProfileState.loading(List<UserProfile> listUserProfiles) = _LoadingState;
//  factory EditProfileState.loaded(List<UserProfile> listUserProfiles) = _LoadedState;
// }

//@immutable
import '../../models/profile_model.dart';

class EditProfileState {
  final List<UserProfile> listUserProfiles;
  const EditProfileState(this.listUserProfiles, );
}
class EditProfileLoadingState extends EditProfileState{
  const EditProfileLoadingState(List<UserProfile> listUserProfiles) : super(listUserProfiles);
}
class EditProfileLoadedState extends EditProfileState{
  const EditProfileLoadedState(List<UserProfile> listUserProfiles) : super(listUserProfiles);
}
class EditProfileGetUserProfilesState extends EditProfileState{
const EditProfileGetUserProfilesState(List<UserProfile> listUserProfiles) : super(listUserProfiles);
}