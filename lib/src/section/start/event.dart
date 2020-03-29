import 'package:equatable/equatable.dart';

abstract class StartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProgressToNextStep extends StartEvent {}
