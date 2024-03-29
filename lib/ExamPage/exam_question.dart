import 'dart:developer';

import 'package:elabv01/ClassPage/class_model.dart';
import 'package:elabv01/ExamPage/Blocs/exam_event.dart';
import 'package:elabv01/ExamPage/question_exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Common/footer.dart';
import '../Drawer/drawer.dart';
import '../common/edit_text.dart';
import '../common/theme.dart';
import '../common/widgets/button_common.dart';
import '../common/widgets/check_box.dart';
import '../common/widgets/dropdown_commonv2.dart';
import 'Blocs/exam_bloc.dart';
import 'Blocs/exam_state.dart';

class ExamQuestionPage extends StatelessWidget {
  const ExamQuestionPage({super.key});

  static provider() {
    return BlocProvider(
      create: ((context) => ExamBloc()..add(ExamQuestionEventLoading())),
      child: const ExamQuestionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController question = TextEditingController();
    final List<TextEditingController> options =
        List.generate(4, (index) => TextEditingController());
    String classId = "";

    return BlocConsumer<ExamBloc, ExamState>(builder: (context, state) {
      // List<Widget> getList() {
      //   List<Widget> childs = state.listQuestions![state.index!].options
      //       .asMap()
      //       .entries
      //       .map((e) => Row(children: <Widget>[
      //             CheckboxCommon(
      //                 onTap: () {
      //                   context.read<ExamBloc>().add(ExamEventCheckQuestion(
      //                       optionIndex: e.key, index: state.index!));
      //                 },
      //                 isChecked: e.value.check),
      //             Expanded(
      //               child: Text(
      //                 e.value.content.toString(),
      //                 maxLines: 4,
      //                 overflow: TextOverflow.ellipsis,
      //                 textDirection: TextDirection.rtl,
      //                 textAlign: TextAlign.left,
      //               ),
      //             ),
      //           ]))
      //       .toList();
      //   return childs;
      // }

      List<Widget> getNewQuestion() {
        List<Widget> childs = state.newQuestion!.options
            .asMap()
            .entries
            .map((e) => Row(children: <Widget>[
                  CheckboxCommon(
                      onTap: () {
                        context.read<ExamBloc>().add(
                            ExamEventCheckAddNewQuestion(optionIndex: e.key));
                      },
                      isChecked: e.value.check),
                  Expanded(
                    child: TextCommon(
                        label: "Option ${e.key + 1}",
                        textEditingController: options[e.key]),
                  ),
                ]))
            .toList();
        return childs;
      }

      // if ((state.listQuestions != null)&&((state.listQuestions)!.isNotEmpty)){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Question for exam"),
          backgroundColor: appTheme.primaryColor,
        ),
        drawer: MyDrawer.provider(),
        bottomNavigationBar: const NavigationBottom(),
        body: ((state.newQuestion != null))
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ButtonCommon(
                        label: 'Import Excel',
                        onTap: () {
                          context.read<ExamBloc>().add(
                                ExamAddQuestionImportFileEvent(),
                              );
                        },
                        icon: Icons.upload_rounded,
                        color: appTheme.primaryColor,
                        padding: 8,
                      ),
                      TextCommon(
                          label: "Question", textEditingController: question),
                      Column(
                        children: getNewQuestion(), //getList(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownCommonClass(
                        items: state.classRooms!,
                        onChanged: (ClassModel value) {
                          classId = value.id;
                          log("giao vien$classId");
                        },
                        title: 'Lựa chọn môn',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonCommon(
                            label: 'Add',
                            onTap: () {
                              if ((classId != "") &&
                                  (state.newQuestion!.selection.isNotEmpty)) {
                                for (int i = 0; i < 4; i++) {
                                  state.newQuestion!.options[i].content =
                                      options[i].text;
                                  state.newQuestion!.options[i].check = false;
                                }
                                context.read<ExamBloc>().add(
                                      ExamAddQuestionEvent(
                                          questionExam: QuestionExam(
                                              selection: [],
                                              question: question.text,
                                              options:
                                                  state.newQuestion!.options,
                                              answer: state
                                                  .newQuestion!.selection[0],
                                              id: '',
                                              subjectId: classId,
                                              examId: "101",
                                              fromDate: 0)),
                                    );
                              }
                            },
                            icon: Icons.add,
                            color: appTheme.primaryColor,
                            padding: 8,
                          ),
                          ButtonCommon(
                            label: 'Update',
                            onTap: () {
                              context.read<ExamBloc>().add(
                                    ExamAddQuestionEvent(
                                        questionExam: QuestionExam(
                                            selection: [],
                                            question: '',
                                            options: [],
                                            answer: 0,
                                            id: '',
                                            subjectId: '',
                                            examId: '',
                                            fromDate: 0)),
                                  );
                            },
                            icon: Icons.edit,
                            color: appTheme.primaryColor,
                            padding: 8,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            // : (state.score != null)
            //     ? Center(
            //         child: Text("You got ${state.score}%!!!"),
            //       )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    }, listener: (BuildContext context, state) {
      if (state is ExamScoreState) {}
    });
  }
}
