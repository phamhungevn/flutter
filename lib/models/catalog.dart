// // Copyright 2019 The Flutter team. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';
// part 'catalog.freezed.dart';
// part 'catalog.g.dart';
// /// A proxy of the catalog of items the user can buy.
// ///
// /// In a real app, this might be backed by a backend and cached on device.
// /// In this sample app, the catalog is procedurally generated and infinite.
// ///
// /// For simplicity, the catalog is expected to be immutable (no products are
// /// expected to be added, removed or changed during the execution of the app).
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
//   Item getById(int id) => Item( id: id, name: itemNames[id % itemNames.length]);
//   Item getBYIdNew(int id) => Item( id: id, name: itemNames[id]);
//   //    Item(id,itemNames[id]);
//   int getTotal() => itemNames.length;
//
//   /// Get item by its position in the catalog.
//   Item getByPosition(int position) {
//    // print("vi tri");
//    // print(position);
//     return getBYIdNew(position);
//     //return getById(position);
//   }
// }
//
// @freezed
// class Item with _$Item{
//   const factory Item({
//     required int id,
//     required String name,
//    // required Color color,
//     @Default(42) int price,
//   }) = _Item;
//   // To make the sample app look nicer, each item is given one of the
//   // Material Design primary colors.
//       //: color = Colors.primaries[id % Colors.primaries.length];
//   //
//   // @override
//   // int get hashCode => id;
//   //
//   // @override
//   // bool operator ==(Object other) => other is Item && other.id == id;
//   factory Item.fromJson(Map<String, Object?> json)
//   => _$ItemFromJson(json);
// }