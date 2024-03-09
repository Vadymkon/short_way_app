part of 'tasker_bloc.dart';

@immutable
abstract class TaskerState {}

//for API requests
class TaskerLoadingState extends TaskerState{
  final int resCode;
  final Map response;
  final String errorMessage;
  Query? query;

  TaskerLoadingState({
    this.query,
    this.resCode = 0,
    this.errorMessage = "",
    this.response = const {}});
}

//for short-way
class TaskerCalculatingState extends TaskerState{
  final double percentDone;

  TaskerCalculatingState({this.percentDone = 0});
}

//final results screens
class TaskerResultState extends TaskerState{
  final Field field;

  TaskerResultState({required this.field});
}

