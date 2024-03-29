import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../common/theme.dart';
import '../common/widgets/check_box.dart';
import '../LoginPage/Model/user.model.dart';
import 'StudentListBloc/student_list_bloc.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  static provider() {
    return BlocProvider(
        create: (BuildContext context) {
          return StudentListBloc()..add(LoadingEvent());
        },
        child: const StudentList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentListBloc, StudentListState>(
        builder: (BuildContext context, state) {
      final List<User> listUser = state.studentList;
      var length = listUser.length;
      final CollectionReference usersFirebase =
          FirebaseFirestore.instance.collection('users');
      // CollectionReference<User> usersRef =  FirebaseFirestore.instance.collection('users').withConverter<User>(
      //   fromFirestore: (snapshot, _) => User.fromMap(snapshot.data()!),
      //   toFirestore: (item, _) => item.toMap(),
      // );
      // Future<List<User>> getUsersList(CollectionReference<User> colRef) async {
      //   final data = await colRef.get().then((value) => value.docs);
      //   return data.map((e) => e.data()).toList();
      // }

      return Scaffold(
        drawer: MyDrawer.provider(),
        body: StreamBuilder(
            stream: usersFirebase.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documentSnapshots =
                    snapshot.data!.docs;
                try {
                  List<User> userList = documentSnapshots
                      .map((e) => User(
                          userId: e['userId'] ?? '',
                          user: e['user'] ?? '',
                          password: e['password'] ?? '',
                          email: e['email'] ?? '',
                          modelData: jsonDecode(e['model_data']) ?? [],
                          status: e['status'] ?? 0,
                          updatedDate: e['updatedDate'] ?? 0,
                          userImage: (jsonDecode(e['userImage']) as List)
                              .map((e) => UserImage.fromMap(e))
                              .toList()))
                      .toList();

                  context
                      .read<StudentListBloc>()
                      .add(StudentListUpdateEvent(userList: userList));
                } catch (e) {
                  log(e.toString());
                }

                return CustomScrollView(
                  slivers: [
                    _MyAppBar(),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => _MyListItem(index, state),
                          childCount: length),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        bottomNavigationBar: const NavigationBottom(),
      );
    });
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: appTheme.primaryColor,
      toolbarHeight: 50,
      title: const Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text(
          'Student List',
          //  textAlign: TextAlign.center,
          //  style: Theme.of(context).textTheme.headline2
        ),
      ),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () => context.read<StudentListBloc>().add(LoadingEvent()),
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  final StudentListState state;

  const _MyListItem(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.studentList.elementAt(index); // .getByPosition(index);
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: LimitedBox(
        maxHeight: 55,
        child: Row(children: [
          CircleAvatar(
              backgroundImage: Image.file(File(item.userImage[0].uRL),
                      key: ValueKey(item.userImage[0].uRL), fit: BoxFit.cover)
                  .image),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.user, style: textTheme, textAlign: TextAlign.left),
                  (item.status == 1)
                      ? CheckboxCommon(
                          isChecked: true,
                          onTap: () {
                            context
                                .read<StudentListBloc>()
                                .add(StudentUpdateEvent(status: 0, user: item));
                          })
                      : CheckboxCommon(
                          isChecked: false,
                          onTap: () {
                            context
                                .read<StudentListBloc>()
                                .add(StudentUpdateEvent(status: 1, user: item));
                          },
                        )
                ]),
          ),
        ]),
      ),

      //_AddButton(item: item),
    );
  }
}
