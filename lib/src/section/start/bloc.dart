import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../matrix.dart';
import 'event.dart';
import 'state.dart';

export 'event.dart';
export 'state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final Matrix _matrix;

  StreamSubscription _errorSub;

  StartBloc(this._matrix) {
    _matrix.userAvaible.then(
      (_) => _errorSub = _matrix.user.updates.listen(
        (_) {},
        onError: ((error, stackTrace) {
          add(_NotifyError(error, stackTrace));
        }),
      ),
    );

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

    if (event is _NotifyError) {
      yield ErrorOccurred(event.error, event.stackTrace);
    }
  }

  @override
  Future<void> close() async {
    await _errorSub.cancel();
    await super.close();
  }
}

class _NotifyLoadingDone extends StartEvent {}

class _NotifyError extends StartEvent {
  final dynamic error;
  final StackTrace stackTrace;

  _NotifyError(this.error, this.stackTrace);
}
