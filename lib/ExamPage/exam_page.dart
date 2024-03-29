import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elabv01/ExamPage/Blocs/exam_event.dart';
import 'package:elabv01/ExamPage/question_exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../common/theme.dart';
import '../common/widgets/button_common.dart';
import '../common/widgets/check_box.dart';
import 'Blocs/exam_bloc.dart';
import 'Blocs/exam_state.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  static provider({required String indexExam}) {
    return BlocProvider(
      create: ((context) =>
          ExamBloc()..add(ExamEventLoading(indexExam: indexExam))),
      child: const ExamPage(),
    );
    // return BlocProvider(
    //   create: ((context) => ExamBloc()..add(ExamEventLoading())
    //   ),
    //   child: const ExamPage(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamBloc, ExamState>(builder: (context, state) {
      List<Widget> getList() {
        List<Widget> childs = state.listQuestions![state.index!].options
            .asMap()
            .entries
            .map((e) => Row(children: <Widget>[
                  CheckboxCommon(
                      onTap: () {
                        context.read<ExamBloc>().add(ExamEventCheckQuestion(
                            optionIndex: e.key, index: state.index!));
                      },
                      isChecked: e.value.check),
                  Expanded(
                    child: Text(
                      e.value.content.toString(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ]))
            .toList();
        return childs;
      }

      final CollectionReference questionsFirebase =
          FirebaseFirestore.instance.collection('questions');
      // if ((state.listQuestions != null)&&((state.listQuestions)!.isNotEmpty)){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Exam"),
          backgroundColor: appTheme.primaryColor,
        ),
        drawer: MyDrawer.provider(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  context
                      .read<ExamBloc>()
                      .add(ExamEventPreviousQuestion(index: state.index!));
                },
                icon: const Icon(Icons.skip_previous),
              ),
            ),
            CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    context
                        .read<ExamBloc>()
                        .add(ExamEventNextQuestion(index: state.index!));
                  },
                  icon: const Icon(Icons.skip_next),
                )),
          ],
        ),
        bottomNavigationBar: const NavigationBottom(),
        body: StreamBuilder(
          stream: questionsFirebase.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documentSnapshots =
                  snapshot.data!.docs;
              try {
                List<QuestionExam> questionList = documentSnapshots
                    .map(
                      (e) => QuestionExam(
                          selection: jsonDecode(e['selection']) ?? [],
                          question: e['question'] ?? '',
                          options: (jsonDecode(e['options']) as List)
                              .map((e) => OptionQuestion.fromJson(e))
                              .toList(),
                          answer: e['answer'] ?? 1,
                          id: e['id'] ?? '',
                          subjectId: e['subjectId'] ?? '',
                          examId: e['examId'] ?? '',
                          fromDate: e['fromDate'] ?? 0),
                    )
                    .toList();
                // print("ghi du lieu tuw firebase${questionList.length}");
                context
                    .read<ExamBloc>()
                    .add(ExamEventFireBaseQuestion(listQuestion: questionList));
              } catch (e) {
                log("co loi giao dien firebase download ${e.toString()}");
              }
              // return ((state.listQuestions != null) &&
              //         ((state.listQuestions)!.isNotEmpty))
              //     ? Padding(
              //         padding: const EdgeInsets.all(8),
              //         child: SingleChildScrollView(
              //           child: Column(
              //             children: [
              //               Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "Câu ${state.index! + 1}:",
              //                       textAlign: TextAlign.left,
              //                     )
              //                   ]),
              //               Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Expanded(
              //                       child: Text(
              //                         state.listQuestions![state.index!]
              //                             .question,
              //                         maxLines: 4,
              //                         overflow: TextOverflow.ellipsis,
              //                         textDirection: TextDirection.rtl,
              //                         textAlign: TextAlign.left,
              //                       ),
              //                     )
              //                   ]),
              //               Column(
              //                 children: getList(),
              //               ),
              //               if (state.index == state.listQuestions!.length - 1)
              //                 Center(
              //                   child: ButtonCommon(
              //                     label: 'Submit',
              //                     onTap: () {
              //                       context
              //                           .read<ExamBloc>()
              //                           .add(ExamEventSubmit());
              //                     },
              //                     icon: Icons.upload_rounded,
              //                     color: appTheme.primaryColor,
              //                     padding: 8,
              //                   ),
              //                 )
              //             ],
              //           ),
              //         ),
              //       )
              //     : (state.score != null)
              //         ? Center(
              //             child: Text(
              //                 "${context.read<ExamBloc>().userName} got ${state.score}%!!!"),
              //           )
              //         : const Center(
              //             child: CircularProgressIndicator(),
              //           );
            }
            return
                  ((state.listQuestions != null) &&
                        ((state.listQuestions)!.isNotEmpty))
                    ?
                Padding(
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Câu ${state.index! + 1}:",
                                      textAlign: TextAlign.left,
                                    )
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.listQuestions![state.index!].question,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ]),
                              Column(
                                children: getList(),
                              ),
                              if (state.index == state.listQuestions!.length - 1)
                                Center(
                                  child: ButtonCommon(
                                    label: 'Submit',
                                    onTap: () {
                                      context
                                          .read<ExamBloc>()
                                          .add(ExamEventSubmit());
                                    },
                                    icon: Icons.upload_rounded,
                                    color: appTheme.primaryColor,
                                    padding: 8,
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    : (state.score != null)
                        ? Center(
                            child: Text(
                                "${context.read<ExamBloc>().userName} got ${state.score}%!!!"),
                          )
                        :
                const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    }, listener: (BuildContext context, state) {
      if (state is ExamScoreState) {}
    });
  }
}
