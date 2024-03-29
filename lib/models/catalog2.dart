// // Copyright 2019 The Flutter team. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'package:flutter/material.dart';
//
//
// class CatalogModel {
//   static List<String> itemNames = [
//     // 'Code Smell',
//     // 'Control Flow',
//     // 'Interpreter',
//     // 'Recursion',
//     // 'Sprint',
//     // 'Heisenbug',
//     // 'Spaghetti',
//     // 'Hydra Code',
//     // 'Off-By-One',
//     // 'Scope',
//   ];
//
//   /// Get item by [id].
//   ///
//   /// In this sample, the catalog is infinite, looping over [itemNames].
//   Item getById(int id) => Item(id, itemNames[id % itemNames.length]);
//   Item getBYIdNew(int id) => Item(id,itemNames[id]);
//   int getTotal() => itemNames.length;
//
//   /// Get item by its position in the catalog.
//   Item getByPosition(int position) {
//     print("vi tri");
//     print(position);
//     return getBYIdNew(position);
//     //return getById(position);
//   }
// }
//
// @immutable
// class Item {
//   final int id;
//   final String name;
//   final Color color;
//   final int price = 42;
//
//   Item(this.id, this.name)
//   // To make the sample app look nicer, each item is given one of the
//   // Material Design primary colors.
//       : color = Colors.primaries[id % Colors.primaries.length];
//
//   @override
//   int get hashCode => id;
//
//   @override
//   bool operator ==(Object other) => other is Item && other.id == id;
// }