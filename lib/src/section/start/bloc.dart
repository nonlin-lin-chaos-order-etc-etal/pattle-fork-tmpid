import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../matrix.dart';
import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final Matrix _matrix;

  StartBloc(this._matrix) {
    _matrix.firstSync.then((_) => add(_NotifyLoadingDone()));
  }

  @override
  StartState get initialState => StartState(currentStep: Step.logo);

  @override
  Stream<StartState> mapEventToState(StartEvent event) async* {
    if (event is ProgressToNextStep) {
      yield StartState(
        currentStep: Step.values[state.currentStep.index + 1],
      );
    }

    if (event is _NotifyLoadingDone) {
      yield Finished();
    }
  }
}

class _NotifyLoadingDone extends StartEvent {}
