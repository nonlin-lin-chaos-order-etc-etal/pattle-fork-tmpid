import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SentryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Initialize extends SentryEvent {}

class ChangeMayReportCrashes extends SentryEvent {
  final bool mayReportCrashes;

  ChangeMayReportCrashes({@required this.mayReportCrashes});

  @override
  List<Object> get props => [mayReportCrashes];
}
