import 'package:equatable/equatable.dart';
import 'package:pattle/src/section/main/models/chat_member.dart';

abstract class ChatSettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatSettingsUninitialized extends ChatSettingsState {}

class MembersLoading extends ChatSettingsState {}

class MembersLoaded extends ChatSettingsState {
  final List<ChatMember> members;

  MembersLoaded(this.members);

  @override
  List<Object> get props => [members];
}
