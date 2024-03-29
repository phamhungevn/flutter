import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../ClassPage/class_model.dart';
import '../../LoginPage/Blocs/login_bloc.dart';
import '../../repository/database_helper.dart';
import '../question_exam_model.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  LoginBloc loginBloc = LoginBloc();
  List<ClassModel> classRooms = [];

  List<QuestionExam> listQuestions = [];
  String userName = "";
  String examId = "";
  QuestionExam newQuestionExam = QuestionExam(
      selection: [],
      question: '',
      options: List.generate(4,
          (index) => OptionQuestion(check: false, content: "", id: index + 1)),
      answer: 0,
      id: '',
      subjectId: '',
      examId: '',
      fromDate: 0);
  late final SharedPreferences prefs;
  int index = 0;

  ExamBloc() : super(ExamLoadingState()) {
    on<ExamEventLoading>((event, emit) async {
      await loading(event, emit);
      //   print("vao day52 ${classRooms.length}");
      emit(ExamLoadedState(
        listQuestions: listQuestions,
        index: index,
      ));
      // print("vao day 3${timeTables.length}");
    });
    on<ExamEventFireBaseQuestion>((event, emit) async {
      List<QuestionExam> firebaseList = [];
      bool totalCheck = false;
      bool check;
      if (event.listQuestion != null) {
        firebaseList = event.listQuestion;
        for (QuestionExam questionExam in firebaseList) {
          check = false;
          for (QuestionExam questionExam2 in listQuestions) {
            if (questionExam.id == questionExam2.id) {
              check = true;
              break;
            }
          }
          if ((!check) && (questionExam.examId == examId)) {
            totalCheck = true;
            await databaseHelper.insertQuestionTable(questionExam);
            //      print("da them moi${questionExam.question} $result");
          }
        }

        //   print("da lay lai danh sach cau hoi ${listQuestions.length}");
      }
      if (totalCheck) {
        //  print("da them moi xong");
        await getListQuestion();
        emit(ExamLoadedState(
          listQuestions: listQuestions,
          index: index,
        ));
        print("xuat ra trang thai moi ${listQuestions.length}");
      }
    });
    on<ExamQuestionEventLoading>((event, emit) async {
      await getCLass();
      await getListQuestion();
      log("vao day question exam ${classRooms.length}");
      emit(ExamQuestionState(
        listQuestions: listQuestions,
        classRooms: classRooms,
        newQuestion: newQuestionExam,
      ));
    });
    on<ExamAddQuestionImportFileEvent>((event, emit) async {
      await getCLass();
      await getListQuestion();
      //    log("vao day question import exam ${classRooms.length}");
      await importFileQuestion();
      await getListQuestion();
      emit(ExamQuestionState(
        listQuestions: listQuestions,
        classRooms: classRooms,
        newQuestion: newQuestionExam,
      ));
    });
    on<ExamAddQuestionEvent>((event, emit) async {
      var uuid = const Uuid();
      newQuestionExam = event.questionExam;
      newQuestionExam.id = uuid.v4();
      final now = DateTime.now();
      //print((now.millisecondsSinceEpoch / 1000).round());
      newQuestionExam.fromDate = (now.millisecondsSinceEpoch / 1000).round();
      await databaseHelper.insertQuestionTable(newQuestionExam);
      listQuestions = await databaseHelper.queryAllQuestions();
      log("vao day question exam add ${newQuestionExam.toJson()}");
      emit(ExamQuestionState(
        listQuestions: listQuestions,
        classRooms: classRooms,
        newQuestion: newQuestionExam,
      ));
    });
    on<ExamEventPreviousQuestion>((event, emit) async {
      index = event.index;
      //print("vao day previous 1 $index");
      if (index > 0) {
        index--;
      }
      // print("vao day previous 2 $index");
      emit(ExamLoadedState(listQuestions: listQuestions, index: index));
      // print("vao day 3${timeTables.length}");
    });
    on<ExamEventNextQuestion>((event, emit) async {
      index = event.index;
      if (listQuestions.length > (index + 1)) {
        index++;
      }
      //   print("vao day52 ${classRooms.length}");
      emit(ExamLoadedState(listQuestions: listQuestions, index: index));
      // print("vao day 3${timeTables.length}");
    });
    on<ExamEventCheckAddNewQuestion>((event, emit) async {
      int optionIndex = event.optionIndex;
      newQuestionExam.options[optionIndex].check =
          !newQuestionExam.options[optionIndex].check;
      if (newQuestionExam.options[optionIndex].check) {
        newQuestionExam.selection.add(newQuestionExam.options[optionIndex].id);
      } else {
        newQuestionExam.selection
            .remove(newQuestionExam.options[optionIndex].id);
      }

      //   print("vao day52 ${classRooms.length}");
      emit(ExamQuestionState(
          listQuestions: listQuestions,
          newQuestion: newQuestionExam,
          classRooms: classRooms));
      // print("vao day 3${timeTables.length}");
    });
    on<ExamEventCheckQuestion>((event, emit) async {
      index = event.index;
      int optionIndex = event.optionIndex;
      listQuestions[index].options[optionIndex].check =
          !listQuestions[index].options[optionIndex].check;
      if (listQuestions[index].options[optionIndex].check) {
        listQuestions[index]
            .selection
            .add(listQuestions[index].options[optionIndex].id);
      } else {
        listQuestions[index]
            .selection
            .remove(listQuestions[index].options[optionIndex].id);
      }

      //   print("vao day52 ${classRooms.length}");
      emit(ExamLoadedState(listQuestions: listQuestions, index: index));
      // print("vao day 3${timeTables.length}");
    });
    on<ExamEventSubmit>((event, emit) async {
      int correctAnswer = 0;
      //int indexResult = 0;

      for (QuestionExam questionExam in listQuestions) {
        for (int selection in questionExam.selection) {
          log("chon $selection");
          // for (int i = 0; i < questionExam.options.length; i++) {
          //  log("so sanh ${questionExam.options[i].id}");
          // log("so sanh ${questionExam.options[i].content}");
          if ((selection == questionExam.answer) &&
              (questionExam.selection.length == 1)) {
            log("ket qua dung ${questionExam.answer}");
            correctAnswer++;
          }
          // }
        }
      }
      int finalResult = (correctAnswer / listQuestions.length * 100).round();
      log("ket qua thi $correctAnswer/${listQuestions.length}");
      emit(ExamScoreState(score: finalResult));
    });
  }

  // String getUserIdByEmail(String email ) {
  //   String userId = loginBloc.getUserIdByEmail(email, userLists)?? '';
  //   return userId;
  // }
  // String getUserEmailByUserId(String userId ) {
  //   String userEmail = loginBloc.getUserEmailByUserId(userId, userLists);
  //   return userEmail;
  // }
  Future<void> getCLass() async {
    classRooms = await databaseHelper.queryAllClassRoom();
  }

  Future<void> getListQuestion() async {
    if (examId != "") {
      // print("vao day 21");
      listQuestions = await databaseHelper.queryAllQuestions(
          where: 'examId=?', arg: examId);
    } else {
      listQuestions = await databaseHelper.queryAllQuestions();
    }
  }

  Future<void> importFileQuestion() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    final CollectionReference questionsFirebase =
        FirebaseFirestore.instance.collection('questions');
    File? file;
    if (result != null) {
      // File
      file = File(result.files.single.path!);
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int rowNumber = 0;
      for (var table in excel.tables.keys) {
        //print(table);
        //  print(excel.tables[table]!.maxColumns);
        // print(excel.tables[table]!.maxRows);
        for (var row in excel.tables[table]!.rows) {
          rowNumber++;
          //print("${row.map((e) => e?.value)}");
          if (rowNumber > 1) {
            QuestionExam questionExam = QuestionExam(
                question: row[0]!.value.toString(),
                options: [
                  OptionQuestion(
                      check: false, content: row[1]!.value.toString(), id: 1),
                  OptionQuestion(
                      check: false, content: row[2]!.value.toString(), id: 2),
                  OptionQuestion(
                      check: false, content: row[3]!.value.toString(), id: 3),
                  OptionQuestion(
                      check: false, content: row[4]!.value.toString(), id: 4)
                ],
                answer: int.parse(row[5]!.value.toString()),
                id: row[6]!.value.toString(),
                subjectId: row[7]!.value.toString(),
                examId: row[8]!.value.toString(),
                fromDate: int.parse(row[9]!.value.toString()),
                selection: []);
            bool check = false;
            await getListQuestion();
            for (QuestionExam question in listQuestions) {
              log("tai${question.toJson()}");
              if (question.id == questionExam.id) {
                check = true;
              }
            }
            if (check == false) {
              int result =
                  await databaseHelper.insertQuestionTable(questionExam);
              await questionsFirebase.add(questionExam.toJson());
              log("ket qua $result");
            }
          }
        }
      }
    } else {
      // User canceled the picker
    }
  }

  Future<List<QuestionExam>> loading(
      ExamEventLoading event, Emitter<ExamState> state) async {
    prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    if (event.indexExam != null) {
      //print("vao day $event.indexExam");
      listQuestions = await databaseHelper.queryAllQuestions(
          where: 'examId = ?', arg: event.indexExam);
      examId = event.indexExam!;
    } else {
      //  print("vao day ko ma de");
      listQuestions = []; //await databaseHelper.queryAllQuestions();
    }

    // QuestionExam questionExam = QuestionExam(
    //     question: "Tiên phong ở lĩnh vực sáng tạo nội dung số trong nhà trường",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //               "Ít sử dụng các chiến lược khuyến khích người học sáng tạo nội dung số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //               "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //               "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //               "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 4,
    //     id: "1",
    //     subjectId: "boiduong",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    // bool check = false;
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam);
    //   log("ket qua $result");
    // }
    // ///lap lai
    // QuestionExam questionExam2 = QuestionExam(
    //     question: "Nội dung nào không phải của chuyên đề 7",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Tổng quan về chuyển đổi số trong giáo dục và quản lý giáo dục",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Xây dựng hệ sinh thái chuyển đổi số trong quản trị hoạt động dạy học, kiểm tra – đánh giá, nghiên cứu khoa học và kết nối cộng đồng",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Phát triển năng lực quản lý quá trình chuyển đổi số ở trường  tiểu học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 4,
    //     id: "2",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam2);
    //   log("ket qua $result");
    // }
    // /////
    // QuestionExam questionExam3 = QuestionExam(
    //     question: "Số hóa tài liệu là gì",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Ít sử dụng các chiến lược khuyến khích người học sáng tạo nội dung số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "là hình thức chuyển đổi thông tin, dữ liệu, tài liệu từ dạng vật lý, analog sang định dạng kỹ thuật số",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 3,
    //     id: "3",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam3);
    //   log("ket qua $result");
    // }
    // ///
    // QuestionExam questionExam9 = QuestionExam(
    //     question: "Số hóa quy trình là gì",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "là hình thức chuyển đổi thông tin, dữ liệu, tài liệu từ dạng vật lý, analog sang định dạng kỹ thuật số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "là việc sử dụng các dữ liệu, tài liệu đã được chuyển sang định dạng kỹ thuật số để cải tiến, thay đổi quy trình vận hành, các quy trình làm việc, hoạt động của tổ chức",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 2,
    //     id: "9",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam9);
    //   log("ket qua $result");
    // }
    // //
    // QuestionExam questionExam4 = QuestionExam(
    //     question: "Chuyển đổi số trong nhà trường là gì",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Ít sử dụng các chiến lược khuyến khích người học sáng tạo nội dung số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "là quá trình thay đổi tổng thể và toàn diện của cá nhân, tổ chức về cách sống, cách làm việc và phương thức sản xuất dựa trên các công nghệ số ",
    //           id: 4)
    //     ],
    //     answer: 4,
    //     id: "4",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam4);
    //   log("ket qua $result");
    // }
    // //
    // QuestionExam questionExam5 = QuestionExam(
    //     question: "Thực tại ảo là gì",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Ít sử dụng các chiến lược khuyến khích người học sáng tạo nội dung số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "là những công nghệ nhập vai cho phép người dùng trải nghiệm nội dung được hiển thị kỹ thuật số trong thế giới thật và ảo",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 2,
    //     id: "5",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam5);
    //   log("ket qua $result");
    // }
    // //
    // QuestionExam questionExam6 = QuestionExam(
    //     question: "Super AI là gì",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Trí tuệ vượt quá nhận thức của một con người",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 1,
    //     id: "6",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam6);
    //   log("ket qua $result");
    // }
    // //
    // QuestionExam questionExam7 = QuestionExam(
    //     question: "Sự cần thiết của chuyển đổi số trong trường tiểu học",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Tăng cường tự chủ và trách nhiệm giải trình",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Thúc đẩy toàn diện và nghiêm túc việc sáng tạo nội dung số của người học",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 1,
    //     id: "7",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam7);
    //   log("ket qua $result");
    // }
    // //
    // QuestionExam questionExam8 = QuestionExam(
    //     question: "Thông tư 09/2021/TT-BGDĐT ngày 30/3/2021 của Bộ Giáo dục và Đào tạo ban hành Quy định về",
    //     options: [
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Ít sử dụng các chiến lược khuyến khích người học sáng tạo nội dung số",
    //           id: 1),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng một loạt các chiến lược sư phạm để thúc đẩy việc sáng tạo nội dung số của người học",
    //           id: 2),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "quản lý và tổ chức dạy học trực tuyến trong cơ ở giáo dục phổ thông và cơ sở giáo dục thường xuyên ",
    //           id: 3),
    //       OptionQuestion(
    //           check: false,
    //           content:
    //           "Sử dụng các định dạng sáng tạo để khuyến khích người học sáng tạo nội dung số",
    //           id: 4)
    //     ],
    //     answer: 3,
    //     id: "8",
    //     subjectId: "Bồi dưỡng",
    //     examId: "01",
    //     fromDate: 101,
    //     selection: []);
    //
    // for (QuestionExam question in listQuestions) {
    //   log("tai${question.toJson()}");
    //   if (question.id == questionExam.id) {
    //     check = true;
    //   }
    // }
    // if (check == false) {
    //   int result = await databaseHelper.insertQuestionTable(questionExam8);
    //   log("ket qua $result");
    // }
    ///het lap lai
    // listQuestions = await databaseHelper.queryAllQuestions();
    //print("vao day51 ${listQuestions.length}");

    return listQuestions;
  }

  void printAllTime() {
    // int timeTableTh=-1;
    // for (TimeTable timeTable in timeTables) {
    //   timeTableTh++;
    //   if (timeTables.elementAt(timeTableTh) != null) {
    //     print("dang tim ${timeTables[timeTableTh].toJson()}");
    //   }
    // }
  }
}
