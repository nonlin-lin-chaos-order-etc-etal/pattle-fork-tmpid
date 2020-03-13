import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class CreateGroupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUsers extends CreateGroupEvent {}

class UpdateGroupName extends CreateGroupEvent {
  final String name;

  UpdateGroupName(this.name);

  @override
  List<Object> get props => [name];
}

class AddMember extends CreateGroupEvent {
  final User user;

  AddMember(this.user);
}

class RemoveMember extends CreateGroupEvent {
  final User user;

  RemoveMember(this.user);
}

class CreateGroup extends CreateGroupEvent {}
