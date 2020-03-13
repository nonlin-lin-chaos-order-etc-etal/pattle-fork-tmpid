import 'package:equatable/equatable.dart';

abstract class ChatSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMembers extends ChatSettingsEvent {
  final bool all;

  FetchMembers({this.all = false});

  @override
  List<Object> get props => [all];
}
