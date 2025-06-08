import 'package:equatable/equatable.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();
  @override
  List<Object> get props => [];
}

class LoadGoals extends GoalsEvent {}

class SaveGoals extends GoalsEvent {
  final int hours;
  final int calls;

  const SaveGoals({required this.hours, required this.calls});

  @override
  List<Object> get props => [hours, calls];
}
