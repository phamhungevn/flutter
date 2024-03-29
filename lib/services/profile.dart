import 'dart:io';


import 'package:flutter/material.dart';
import '../common/widgets/app_button.dart';




class Profile extends StatelessWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(imagePath)),
                    ),
                  ),
                  margin: const EdgeInsets.all(20),
                  width: 50,
                  height: 50,
                ),
                Text(
                  'Hi $username!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Spacer(),
            AppButton(
              text: "HomePage",
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyHomePage1()),
                // );
                Navigator.pushReplacementNamed(context, '/displayPerson');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              color: const Color(0xFFFF6161),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
