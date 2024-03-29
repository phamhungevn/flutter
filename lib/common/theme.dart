// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

final appTheme = ThemeData(
  dialogBackgroundColor: Colors.grey[200],//Colors.redAccent[700],//Color(0xFFFFFB7D),// Color(0xFFF7CE68),//Color(0xFFFBAB7E),//Color(0xFFFBDA61),//Color(0xFFFF5ACD),// Colors.grey[50] ,
  primaryColor: Colors.blueAccent[700],//Color(0xFF0F0BDB)[50],//
  primaryColorLight: Colors.green,
  primaryColorDark: Colors.blue[100],//const Color(0xff4267B2),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: Colors.green,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Colors.black,
    ),
  ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(background: Colors.white38),
    buttonTheme: const ButtonThemeData(
     // buttonColor: Colors.deepPurple,     //  <-- dark color
      textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
    ),
  appBarTheme: AppBarTheme(
    titleTextStyle:const TextStyle( color: Colors.white),

    toolbarTextStyle:  TextStyle( color: Colors.blueAccent[700]),
    ),
  );
