import 'package:toast/toast.dart';

import '../common/theme.dart';
import '../common/widgets/button_common.dart';
import 'package:flutter/material.dart';
import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../common/edit_text.dart';
import '../common/widgets/date_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/class_room_bloc.dart';
import 'Bloc/class_room_event.dart';
import 'Bloc/class_room_state.dart';

class ClassRoom extends StatelessWidget {
  const ClassRoom({super.key});

  static provider() {
    return BlocProvider(
      create: (BuildContext context) {
        return ClassRoomBloc();
      },
      child: const ClassRoom(),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fromDate = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Tạo lớp học"),
      backgroundColor: appTheme.primaryColor,),
      drawer: MyDrawer.provider(),
      body: _BuildBody(fromDate),
      bottomNavigationBar: const NavigationBottom(),
    );
  }
}

class _BuildBody extends StatefulWidget {
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController noHour = TextEditingController();
  final TextEditingController noSession = TextEditingController();
  final TextEditingController toDate = TextEditingController();
  final TextEditingController faculty = TextEditingController();

  _BuildBody(TextEditingController fromDate) {
    fromDate = fromDate;
  }

  @override
  State<_BuildBody> createState() => BuildBodyState();
}

class BuildBodyState extends State<_BuildBody> {
  late int fromDateInt;
  late int toDateInt;

  @override
  Widget build(BuildContext context) {
    int getDate(TextEditingController date) {
      showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return Center(
                child: AlertDialog(
                  title: const Text('Welcome'),
                  content: GetDate(
                    onChanged: (DateTime value) {
                      setState(
                        () {
                          date.text = value.toString();
                        },
                      );
                      return value.second;
                    },
                  ),
                  actions: [
                    ButtonCommon(
                      label: "Close",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      icon: Icons.add_box_rounded,
                      color: appTheme.primaryColor,
                      padding: 10,
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
      return 0;
    }

    return BlocConsumer<ClassRoomBloc, ClassRoomState>(
      builder: (BuildContext context, state) {
        fromDateInt = state.fromDate ?? 0;
        toDateInt = state.toDate ?? 0;
        return Container(
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TextCommon(label: "Name", textEditingController: widget.name),
                  TextCommon(
                      label: "From date",
                      textEditingController: widget.fromDate),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCommon(
                          label: "From",
                          onTap: () {
                            fromDateInt = getDate(widget.fromDate);
                          },
                          icon: Icons.add,
                          color: appTheme.primaryColor,
                          padding: 10),
                      ButtonCommon(
                          label: "To",
                          onTap: () {
                            toDateInt = getDate(
                              widget.toDate,
                            );
                          },
                          icon: Icons.add,
                          color: appTheme.primaryColor,
                          padding: 10),
                    ],
                  ),
                  TextCommon(
                      label: "To date", textEditingController: widget.toDate),
                  TextCommon(
                      label: "Number of Hour",
                      textEditingController: widget.noHour),
                  TextCommon(
                      label: "Number of session",
                      textEditingController: widget.noSession),
                  TextCommon(
                      label: "Faculty", textEditingController: widget.faculty),
                  ButtonCommon(
                      label: "Add",
                      onTap: () {
                        //print("vaoday"+widget.name.text);
                        context.read<ClassRoomBloc>().add(RoomAddEvent(
                            fromDate: fromDateInt,
                            name: widget.name.text,
                            toDate: toDateInt,
                            numberSession: int.parse(widget.noSession.text),
                            numberHour: int.parse(widget.noHour.text),
                            faculty: widget.faculty.text));
                      },
                      icon: Icons.add,
                      color: appTheme.primaryColor,
                      padding: 10)
                ],
              ),
            ));
      },
      listener: (BuildContext context, state) {
        if (state is ClassRoomAddedState) {
          ToastContext().init(context);
          Toast.show("Added new class");
        }
        if (state is ClassRoomErrorState) {
          ToastContext().init(context);
          Toast.show("Failed to add new class");
        }
      },
    );
  }
}
