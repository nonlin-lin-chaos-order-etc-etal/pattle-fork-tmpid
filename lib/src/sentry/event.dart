import 'package:equatable/equatable.dart';

abstract class SentryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Initialize extends SentryEvent {}

class ChangeMayReportCrashes extends SentryEvent {
  final bool mayReportCrashes;

  ChangeMayReportCrashes(this.mayReportCrashes);

  @override
  List<Object> get props => [mayReportCrashes];
}
