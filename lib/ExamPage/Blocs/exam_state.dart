import '../../ClassPage/class_model.dart';
import '../question_exam_model.dart';

class ExamState {
  final List<QuestionExam>? listQuestions;
  final QuestionExam? newQuestion;
  final List<ClassModel>? classRooms;
  final int? index;
  final int? score;

  ExamState({this.index, this.newQuestion, this.listQuestions,this.score, this.classRooms});
}

class ExamLoadingState extends ExamState {
}

class ExamLoadedState extends ExamState {
  ExamLoadedState({required List<QuestionExam> listQuestions, required int index})
      : super(listQuestions: listQuestions, index: index);
}
class ExamQuestionState extends ExamState {
  ExamQuestionState({required List<QuestionExam> listQuestions, required QuestionExam newQuestion, required List<ClassModel> classRooms})
      : super(listQuestions: listQuestions, newQuestion: newQuestion, classRooms: classRooms);
}
class ExamScoreState extends ExamState {
  ExamScoreState({required int score})
      : super(score:score);
}
class ExamErrorState extends ExamState {}
