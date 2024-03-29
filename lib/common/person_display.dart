import 'package:elabv01/common/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



import '../Drawer/drawer.dart';
import '../models/match_cart_model.dart';

import 'package:provider/provider.dart';

import '../models/profile_model.dart';
import 'footer.dart';
class PersonDisplay extends StatefulWidget{
  const PersonDisplay({Key? key}) : super(key: key);

  @override
  State<PersonDisplay> createState() => _PersonDisplayState();

}

class _PersonDisplayState extends State<PersonDisplay> {
  int imageIndex = 0;
  var userIndex = 0;
  double _currentSliderValue =1;
  bool nextUser = true;
  var length = 0;
  List userList =[];
  var matchUsers= MatchCartModel();
  void ignorePerson(){
    setState(() {
      if (nextUser)
       {
         if (userList.length > (userIndex + 1)) {
           userIndex++;
         } else {
           nextUser = false;
         }
      }

    });
  }

  void likePerson(BuildContext context, UserProfile user) {
    setState(() {
      if (nextUser) {
        matchUsers.add(user);
        if (userList.length > (userIndex + 1)) {
          userIndex++;
        } else {
          nextUser = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    userList = context.read<UserProfileModel>().userProfile;
    matchUsers = context.read<MatchCartModel>();
    return
        Scaffold(
            appBar: AppBar(
              title: const Text("Danh sách sinh viên"),
              backgroundColor: appTheme.primaryColor,
            ),
            drawer: MyDrawer.provider(),
            body: (kIsWeb)
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Slider(
                        key: Key(_currentSliderValue.toString()),
                        value: _currentSliderValue,
                        max: 6,
                        divisions: 6,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            if (value >= 1) {
                              imageIndex = (value - 1) as int;
                            }
                            _currentSliderValue = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Image.network(
                                userList[userIndex].userImage[imageIndex].uRL,
                                key: ValueKey(
                                  userList[userIndex].userImage[imageIndex].uRL,
                                ),
                                fit: BoxFit.fill,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Image.network(
                          userList[userIndex].userImage[imageIndex].uRL,
                          key: ValueKey(
                            userList[userIndex].userImage[imageIndex].uRL,
                          ),
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: ignorePerson,
                    icon: const Icon(Icons.content_cut_sharp),
                  ),
                ),
                CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        likePerson(context, userList[userIndex]);
                      },
                      icon: const Icon(Icons.add),
                    )),
              ],
            ),
            bottomNavigationBar: const NavigationBottom());

  }
}