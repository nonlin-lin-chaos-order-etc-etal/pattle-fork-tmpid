import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pattle/src/section/main/models/chat_message.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final int pageCount;
  final List<ChatMessage> messages;
  final endReached;

  ChatLoaded({
    @required this.messages,
    @required this.pageCount,
    this.endReached = true,
  });

  ChatLoaded copyWith({
    @required List<ChatMessage> messages,
    @required int pageCount,
    bool endReached = true,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      pageCount: pageCount ?? this.pageCount,
      endReached: endReached ?? this.endReached,
    );
  }

  @override
  List<Object> get props => [messages, pageCount, endReached];
}
