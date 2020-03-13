import 'package:equatable/equatable.dart';
import 'package:pattle/src/section/main/chats/models/chat_overview.dart';

abstract class ChatsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<ChatOverview> chats;

  ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}
