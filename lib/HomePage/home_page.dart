import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elabv01/ExamPage/exam_page.dart';
import 'package:flutter/material.dart';

import '../Drawer/drawer.dart';
import '../common/theme.dart';
import 'exam_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //   List subject = [
    //     "Bồi Dưỡng 01",
    //     "Bồi Dưỡng 02",
    //     "Bồi Dưỡng 03",
    //     "Bồi Dưỡng 04",
    //     "Bồi Dưỡng 05",
    //     "Bồi Dưỡng 06",
    //     "Bồi Dưỡng 07",
    //     "Bồi Dưỡng 08",
    //   ];
    List<ExamModel> examList = [];
    void itemCLick(int index) {
      //  Navigator.pushReplacementNamed(context, '/examPage', arguments: {'index': '01'});
      if (examList[index].status == 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExamPage.provider(indexExam: examList[index].examId),
          ),
        );
      }
    }

    final CollectionReference examsFirebase =
        FirebaseFirestore.instance.collection('listexams');
    return Scaffold(
        appBar: AppBar(
          title: const Text("Exam List"),
          backgroundColor: appTheme.primaryColor,
        ),
        drawer: MyDrawer.provider(),
        body: StreamBuilder(
            stream: examsFirebase.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documentSnapshots =
                    snapshot.data!.docs;
                try {
                  examList = documentSnapshots
                      .map((e) => ExamModel(
                          name: e['name'] ?? '',
                          status: e['status'] ?? '',
                          examId: e['examId'] ?? ''))
                      .toList();
                } catch (e) {
                  log(e.toString());
                }
                return Container(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: examList.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (examList[index].status == 1)
                                      ? Image.asset(
                                          'images/lake.jpg',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : const SizedBox(),
                                  (examList[index].status == 1)
                                      ? Text(examList[index].name,
                                          style: const TextStyle(fontSize: 20))
                                      : const SizedBox()
                                ],
                              ),
                            ),
                            onTap: () {
                              itemCLick(index);
                            });
                      },
                    ));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
