import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class ChatSettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatSettingsUninitialized extends ChatSettingsState {}

class MembersLoading extends ChatSettingsState {}

class MembersLoaded extends ChatSettingsState {
  final List<User> members;

  MembersLoaded(this.members);

  @override
  List<Object> get props => [members];
}
