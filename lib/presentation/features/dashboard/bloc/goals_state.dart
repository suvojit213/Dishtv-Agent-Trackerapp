import 'package:equatable/equatable.dart';

class GoalsState extends Equatable {
  final int targetHours;
  final int targetCalls;
  final bool isLoading;

  const GoalsState({
    this.targetHours = 150,
    this.targetCalls = 1000,
    this.isLoading = true,
  });

  GoalsState copyWith({
    int? targetHours,
    int? targetCalls,
    bool? isLoading,
  }) {
    return GoalsState(
      targetHours: targetHours ?? this.targetHours,
      targetCalls: targetCalls ?? this.targetCalls,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [targetHours, targetCalls, isLoading];
}
