// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:elabv01/AppointmentPage/Bloc/appointment_bloc.dart';
import 'package:elabv01/AppointmentPage/Bloc/appointment_event.dart';
import 'package:elabv01/AppointmentPage/Bloc/appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Drawer/drawer.dart';
import '../common/theme.dart';
import 'utils.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  static provider() {
    return BlocProvider(
      create: (BuildContext context) {
        return AppointmentBloc()..add(AppointmentEventLoading());
      },
      child: const Appointment(),
    );
  }

  @override
  AppointmentState createState() => AppointmentState();
}

class AppointmentState extends State<Appointment> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  var kEvents2 = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {

  //  for (var event in kEvents2.keys){
     // print("su kien2 $event");
    //  for (Event event2 in kEvents2[kEvents2.keys] ?? []){
       // for (Event event in kEvents2[kEvents2.keys] ?? []){
    //    print("su kien 3 ${event2.title}");
   //   }
 //   }
 //    for (Event event in kEvents2[day] ?? []){
 //      print("su kien${event.title}");
 //    }
    return kEvents2[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    // for (final d in days){
    //   for (Event event in _getEventsForDay(d)){
    //     print("vao day 2 ${event.title}");
    //   }
    // }
      return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }
//se duoc goi khi bam chon ngay cu the
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
    _selectedEvents.value = _getEventsForDay(focusedDay);
   // _selectedEvents.value = _getEventsForDays(_selectedDays);
   //  for (Event event in _selectedEvents.value){
   //    print("vaoday 1${event.title}");
   //  }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
 //   print("selected events${_selectedEvents.toString()}");
    return BlocConsumer<AppointmentBloc,AppointmentBlocState>(builder: (context,state){
      return   Scaffold(
        drawer: MyDrawer.provider(),
        appBar: AppBar(
          title: const Text('Appointment'),
          backgroundColor: appTheme.primaryColor,
        ),
        body: Column(
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _focusedDay,
              builder: (context, value, _) {
                return _CalendarHeader(
                  focusedDay: value,
                  clearButtonVisible: canClearSelection,
                  onTodayButtonTap: () {
                    setState(() => _focusedDay.value = DateTime.now());
                  },
                  onClearButtonTap: () {
                    setState(() {
                      _rangeStart = null;
                      _rangeEnd = null;
                      _selectedDays.clear();
                      _selectedEvents.value = [];
                    });
                  },
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay.value,
              headerVisible: true,
              //false,
              selectedDayPredicate: (day) => _selectedDays.contains(day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              holidayPredicate: (day) {
                // Every 20th day of the month will be treated as a holiday
                return day.day == 20;
              },
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onCalendarCreated: (controller) => _pageController = controller,
              onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => {} // print('${value[index]}')
                          ,
                          title: Text('Diem danh ${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }, listener: (context,state){
      if (state is AppointmentStateLoaded){
        kEvents2= state.listEvents!;
      }

    });

  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
