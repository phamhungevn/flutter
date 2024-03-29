import '../question_exam_model.dart';

abstract class ExamEvent {}

class ExamEventAdd extends ExamEvent {
  final String? dayID;

  final String? sessionID;
  final String? subjectID;
  final String? roomID;
  final String? userID;
  final int? action;

  final List<int>? arr;

  ExamEventAdd(
      {required this.dayID,
      required this.sessionID,
      required this.subjectID,
      required this.roomID,
      required this.userID,
      required this.action,
      required this.arr});
}
class ExamEventLoading extends ExamEvent {
  String? indexExam;
  ExamEventLoading({this.indexExam});
}
class ExamQuestionEventLoading extends ExamEvent {}
class ExamEventNextQuestion extends ExamEvent {
  final int index;
  ExamEventNextQuestion({required this.index});
}
class ExamEventFireBaseQuestion extends ExamEvent {
  final List<QuestionExam> listQuestion;
  ExamEventFireBaseQuestion({required this.listQuestion});
}
class ExamAddQuestionImportFileEvent extends ExamEvent{}
class ExamEventCheckQuestion extends ExamEvent {
  final int index;
  final int optionIndex;
  ExamEventCheckQuestion({required this.optionIndex, required this.index});
}
class ExamEventCheckAddNewQuestion extends ExamEvent {
  final int optionIndex;
  ExamEventCheckAddNewQuestion({required this.optionIndex,});
}
class ExamEventPreviousQuestion extends ExamEvent {
  final int index;
  ExamEventPreviousQuestion({required this.index});
}
class ExamAddQuestionEvent extends ExamEvent {
  final QuestionExam questionExam;
  ExamAddQuestionEvent({required this.questionExam});
}
class ExamEventSubmit extends ExamEvent {}

