part of 'student_list_bloc.dart';

class StudentListState {
  final List<User> studentList;

  const StudentListState(this.studentList);
}

class _LoadingState extends StudentListState {
  const _LoadingState(List<User> studentList) : super(studentList);
}

class _LoadedState extends StudentListState {
  const _LoadedState(List<User> studentList) : super(studentList);
}
