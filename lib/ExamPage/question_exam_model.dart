import 'dart:convert';

import '../LoginPage/Model/user.model.dart';

class ResultExam {
  String resultId = "";
  String userId = "";
  String examId = "";
  String score = "";
  int updatedDate = 0;

  ResultExam(
      {required this.resultId,
      required this.userId,
      required this.examId,
      required this.score,
      required this.updatedDate});

  toJson() {
    return {
      'resultId': resultId,
      'userId': userId,
      'examId': examId,
      'score': score,
      'updatedDate': updatedDate
    };
  }

  static ResultExam fromJson(Map<String, dynamic> resultExam) {
    return ResultExam(
        resultId: resultExam['resultId'] ?? "",
        userId: resultExam['userId'] ?? "",
        examId: resultExam['examId'] ?? "",
        score: resultExam['score'] ?? 0,
        updatedDate: resultExam['resultId'] ?? 0,);
  }
}

class OptionQuestion {
  String content = '';
  bool check;
  int id;

  OptionQuestion(
      {required this.check, required this.content, required this.id});

  toJson() {
    return {'content': content, 'check': check, 'id': id};
  }

  static OptionQuestion fromJson(Map<String, dynamic> optionQuestion) {
    return OptionQuestion(
        check: optionQuestion['check'] ?? false,
        id: optionQuestion['id'] ?? 0,
        content: optionQuestion['content'] ?? "");
  }
}

class QuestionExam {
  UserImage? questionImage;
  String question;
  List<OptionQuestion> options;
  int answer;
  List selection;
  String id;
  String subjectId;
  String examId;
  int fromDate;

  QuestionExam({
    this.questionImage,
    required this.selection,
    required this.question,
    required this.options,
    required this.answer,
    required this.id,
    required this.subjectId,
    required this.examId,
    required this.fromDate,
  });

  toJson() {
    return {
      'id': id,
      'questionImage': (questionImage != null) ? questionImage!.toMap() : null,
      'question': question,
      'options': jsonEncode(options
          .map((e) =>
              OptionQuestion(check: e.check, content: e.content, id: e.id)
                  .toJson())
          .toList()),
      'answer': answer,
      'selection': jsonEncode(selection),
      'subjectId': subjectId,
      'examId': examId,
      'fromDate': fromDate
    };
  }

  static QuestionExam fromJson(Map<String, dynamic> questionExam) {
    return QuestionExam(
      questionImage: (questionExam['questionImage'] != null)
          ? (questionExam['questionImage']).map((e) => UserImage.fromMap(e))
          : null,
      question: questionExam['question'] ?? "",
      options: (jsonDecode(questionExam['options']) as List)
          .map((e) => OptionQuestion.fromJson(e))
          .toList(),
      selection: (questionExam['selection'] != null)
          ? jsonDecode(questionExam['selection'])
          : [],
      answer: questionExam['answer'] ?? 0,
      id: questionExam['id'] ?? '',
      subjectId: questionExam['subjectId'] ?? '',
      examId: questionExam['examId'] ?? "",
      fromDate: questionExam['fromDate'] ?? 0,
    );
  }
}
