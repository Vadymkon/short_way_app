part of 'tasker_bloc.dart';

@immutable
abstract class TaskerEvent {}

class TaskerOnSendEvent extends TaskerEvent {
  final Query query;


  TaskerOnSendEvent({required this.query});
}

class TaskerOnCalculateEvent extends TaskerEvent {}