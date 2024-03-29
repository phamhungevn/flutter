import 'package:flutter/material.dart';
class NavigationBottom extends StatelessWidget{
  const NavigationBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Row(mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(child: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/displayPerson');
          },
          icon: const Icon(Icons.search),
        ),),
        Flexible(child: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/matchedUsers');
          },
          icon: const Icon(Icons.message),
        ),),
        Flexible(child: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/searchCondition');
          },
          icon: const Icon(Icons.edit),
        ),),
        Flexible(child: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/editProfile');
          },
          icon: const Icon(Icons.person),
        ),)
      ],
    );
  }

}