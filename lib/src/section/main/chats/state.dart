import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../models/chat.dart';

abstract class ChatsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> personal;
  final List<Chat> public;

  ChatsLoaded({@required this.personal, @required this.public});

  @override
  List<Object> get props => [personal];
}
