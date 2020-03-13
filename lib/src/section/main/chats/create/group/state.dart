import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:matrix_sdk/matrix_sdk.dart';

abstract class CreateGroupState extends Equatable {
  final List<User> members;

  CreateGroupState(this.members);

  @override
  List<Object> get props => [];
}

class InitialCreateGroupState extends CreateGroupState {
  InitialCreateGroupState() : super([]);
}

class UserListUpdated extends CreateGroupState {
  final List<User> users;

  UserListUpdated(
    this.users, {
    @required List<User> members,
  }) : super(members);

  @override
  List<Object> get props => [users];
}

class MemberListUpdated extends CreateGroupState {
  MemberListUpdated(List<User> members) : super(members);

  @override
  List<Object> get props => [members];
}

class CreatingGroup extends CreateGroupState {
  CreatingGroup({@required List<User> members}) : super(members);
}

class CreatedGroup extends CreateGroupState {
  final Room room;

  CreatedGroup(
    this.room, {
    @required List<User> members,
  }) : super(members);

  @override
  List<Object> get props => [room];
}
