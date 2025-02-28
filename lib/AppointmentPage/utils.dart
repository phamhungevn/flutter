// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);
int k=0;
// for (var item in List.generate(50, (index) => index))
// // {
// DateTime(kFirstDay.year, kFirstDay.month, item * 7):
// List.generate(1, (index) => Event('Event $item | ${index + 1}'))
final _kEventSource = {
//var item in List.generate(50, (index) => index)

// while (k<=50){
// DateTime(kFirstDay.year, kFirstDay.month, k):
// List.generate(1, (k) => Event('Event $k | ${k + 1}'))
// }

  for (var item in List.generate(50, (index) => index))
   // {
      DateTime(kFirstDay.year, kFirstDay.month, item * 7):
      List.generate(1, (index) => Event('Event $item | ${index + 1}'))//..add(  kToday: [])
   // }
};
// ..addAll({
//     kToday: [
      // const Event('Today\'s Event 1'),
      // const Event('Today\'s Event 2'),
  //   ],
  // });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, 1, 1); // kToday.month - 3, kToday.day);
final kLastDay =
    DateTime(kToday.year, 12, kToday.day); //kToday.month + 3, kToday.day);
