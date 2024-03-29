import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/switch_button.dart';
import '../../common/dropdown_common.dart';
import '../../common/edit_text.dart';
import '../../common/save_local.dart';
import '../../common/theme.dart';
import '../Common/footer.dart';
import '../TakePicture/take_picture.dart';
import '../models/profile_model.dart';
import 'Blocs/edit_profile_bloc.dart';
import 'Blocs/edit_profile_event.dart';
import 'Blocs/edit_profile_state.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  static provider() {
    return BlocProvider(
      create: (BuildContext context) {
        return EditProfileBloc()..add(EditProfileGetUserProfilesEvent());
      },
      child: const EditProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa hồ sơ")),
      body: const EditProfileView(),
      bottomNavigationBar: const NavigationBottom(),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userIndex = 1;
    final TextEditingController mIntroduction = TextEditingController();

    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (BuildContext context, state) {
      final listUser = state.listUserProfiles;

      if (listUser.isEmpty) {
        return const Scaffold(body: TextCommon(label: "running"));
      } else {
        return Material(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  itemCount: listUser[userIndex].userImage.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        child: SelectionPicture(
                      userIndex: userIndex,
                      imageIndex: index,
                      userList: listUser,
                    ));
                  },
                ),
              ),
              TextCommon(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                label: "Giới thiệu",
                textEditingController: mIntroduction,
              ),
              const MultiSelectDropdownCommon(title: 'Thể thao'),
              const MyGenderRadio(
                textStr: 'Giới tính',
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Chia sẻ vị trí của mình"),
                  ),
                  LocationSwitch()
                ],
              )
            ],
          ),
        );
      }
    });
  }
//);
//}
}

class SelectionPicture extends StatefulWidget {
  const SelectionPicture(
      {Key? key,
      required this.imageIndex,
      required this.userList,
      required this.userIndex})
      : super(key: key);
  final int imageIndex;
  final int userIndex;
  final List<UserProfile> userList;

  @override
  State<SelectionPicture> createState() => _SelectionPicture();
}

class _SelectionPicture extends State<SelectionPicture> {
  final ImagePicker _picker = ImagePicker();
   Future<String?> take(CameraDescription usedCamera){
     return Navigator.pushNamed(context, '/takePicture',
         arguments: ArgumentsTakePicture(widget.imageIndex, usedCamera));
   }
  Future<void> takePicture({required int index}) async {
    List<CameraDescription> cameras = [];
    late CameraDescription usedCamera;
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    final firstCamera = cameras.first;
    usedCamera = firstCamera;
    final imagePath = await take(usedCamera);
    if (imagePath != null) {
      String newPath = await SaveLocal(imagePath.toString()).saveToLocal();
      setState(() {
        widget.userList[widget.userIndex].userImage[index].uRL = newPath;
        widget.userList[widget.userIndex].userImage[index].source =
            ImagePath.camera;
      });
    }
  }

  Future<bool> getImageAndSave(
      {required int index, required int userIndex}) async {
    final imagePath =
        widget.userList[widget.userIndex].userImage[widget.imageIndex].uRL;
    context.read<EditProfileBloc>().add(EditProfileRotatePictureEvent(
        imagePath: imagePath, imageIndex: index, userIndex: userIndex));
    return true;
  }

  Future<void> imagePick({required int index, required int userIndex}) async {
    XFile? image;
    try {
      image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          widget.userList[widget.userIndex].userImage[index].source =
              ImagePath.gallery;

          widget.userList[widget.userIndex].userImage[index].uRL = image!.path;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
  Widget alert(String title, String message, String button) {
    return
      AlertDialog(
        title: Text(title),
        content:  Text(message),
        actions: [
          ElevatedButton(
            child: Text(button),
            onPressed: () async {
              Navigator.pop(context,true);
            },
          ),
        ],
      );
  }
  @override
  Widget build(BuildContext context) {
    // final List<UserProfile> userList = context.read<EditProfileBloc>().state.listUserProfiles.cast<UserProfile>();
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.green,
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ((widget.userList[widget.userIndex].userImage[widget.imageIndex]
                            .source ==
                        ImagePath.network) ||
                    (kIsWeb))
                ? Image.network(
                    widget.userList[widget.userIndex]
                        .userImage[widget.imageIndex].uRL,
                    key: ValueKey(widget.userList[widget.userIndex]
                        .userImage[widget.imageIndex].uRL),
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(widget.userList[widget.userIndex]
                        .userImage[widget.imageIndex].uRL),
                    key: ValueKey(widget.userList[widget.userIndex]
                        .userImage[widget.imageIndex].uRL),
                    fit: BoxFit.fill),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.rotate_90_degrees_cw,
                          size: 15,
                        ),
                        onPressed: () async {
                          bool result = await showDialog(context: context, builder: (BuildContext context){
                            return alert("Chuẩn bị", "ảnh", "Quay");
                          });
                          if (result) {
                           // bool selected =false;
                           //  selected = await getImageAndSave(
                           //      index: widget.imageIndex,
                           //      userIndex: widget.userIndex);


                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 15,
                        ),
                        onPressed: () {
                          takePicture(index: widget.imageIndex);
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        ),
                        onPressed: () {
                          imagePick(
                              index: widget.imageIndex,
                              userIndex: widget.userIndex);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum Gender { nam, nu }

class MyGenderRadio extends StatefulWidget {
  const MyGenderRadio({
    Key? key,
    required this.textStr,
  }) : super(key: key);
  final String textStr;

  @override
  State<MyGenderRadio> createState() => _MyGenderRadioState();
}

class _MyGenderRadioState extends State<MyGenderRadio> {
  Gender gender = Gender.nam;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.textStr,
                  style: appTheme.textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: Text(Gender.nam.name),
                    leading: Radio<Gender>(
                      value: Gender.nam,
                      groupValue: gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(Gender.nu.name),
                    leading: Radio<Gender>(
                      value: Gender.nu,
                      groupValue: gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ))
          ],
        )
      ],
    );
  }
}

