import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SentryState extends Equatable {
  final bool mayReportCrashes;

  SentryState(this.mayReportCrashes);

  @override
  List<Object> get props => [mayReportCrashes];
}

class NotInitialized extends SentryState {
  NotInitialized({bool mayReportCrashes}) : super(mayReportCrashes ?? false);
}

class Initialized extends SentryState {
  Initialized({@required bool mayReportCrashes}) : super(mayReportCrashes);
}
