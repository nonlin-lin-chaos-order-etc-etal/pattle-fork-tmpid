import 'package:equatable/equatable.dart';

import '../../../models/chat_member.dart';

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
  final ChatMember member;

  AddMember(this.member);
}

class RemoveMember extends CreateGroupEvent {
  final ChatMember member;

  RemoveMember(this.member);
}

class CreateGroup extends CreateGroupEvent {}
