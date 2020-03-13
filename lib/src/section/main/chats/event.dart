import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPersonalChats extends ChatsEvent {}

class LoadPublicChats extends ChatsEvent {}
