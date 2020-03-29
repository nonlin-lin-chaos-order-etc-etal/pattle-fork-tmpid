import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

enum Step {
  logo,
  login,
  loading,
}

class StartState extends Equatable {
  final Step currentStep;

  StartState({@required this.currentStep});

  @override
  List<Object> get props => [currentStep];
}

class Finished extends StartState {}
